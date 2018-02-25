---
title: 孤儿进程、僵尸进程与 Docker
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags: ['Docker', '进程', '僵尸进程']
categories: ['技术']
date: 2016-02-17 20:10:28
updated: 2016-02-17 20:10:28
---


## 前言(Intro)

我们知道当子进程还在运行时，其直接父进程被 kill 掉以后，这个子进程会变成孤儿进程（orphaned process），然后它会被 init 进程接管。

在 docker 容器中运行的进程，一般是没有 init 进程的。你可以进入容器使用 `ps` 查看，会发现 pid 为 1 的进程并不是 init，而是容器的主进程。

那么问题来了，如果容器中产生了孤儿进程，谁来接管这个进程？

<!-- more -->

## 孤儿进程如何被接管？

其实“孤儿进程是会被 init 进程接管的”并不是真相，只不过结论上来说是这样。
网上也有人说是孤儿进程会被 pid 为 1 的进程接管，而 init 进程刚好就是那个 pid 为 1 的进程。这说的不是很准确。

不如直接来看 [linux 内核源码](https://github.com/torvalds/linux/blob/eae21770b4fed5597623aad0d618190fa60426ff/kernel/exit.c#L479)

```c
/*
 * When we die, we re-parent all our children, and try to:
 * 1. give them to another thread in our thread group, if such a member exists
 * 2. give it to the first ancestor process which prctl'd itself as a
 *    child_subreaper for its children (like a service manager)
 * 3. give it to the init process (PID 1) in our pid namespace
 */
static struct task_struct *find_new_reaper(struct task_struct *father,
                       struct task_struct *child_reaper)
{
    struct task_struct *thread, *reaper;

    thread = find_alive_thread(father);
    if (thread)
        return thread;

    if (father->signal->has_child_subreaper) {
        /*
         * Find the first ->is_child_subreaper ancestor in our pid_ns.
         * We start from father to ensure we can not look into another
         * namespace, this is safe because all its threads are dead.
         */
        for (reaper = father;
             !same_thread_group(reaper, child_reaper);
             reaper = reaper->real_parent) {
            /* call_usermodehelper() descendants need this check */
            if (reaper == &init_task)
                break;
            if (!reaper->signal->is_child_subreaper)
                continue;
            thread = find_alive_thread(reaper);
            if (thread)
                return thread;
        }
    }

    return child_reaper;
}
```

接管分三步，第一步是找到相同线程组里其他可用的线程，如果没有找到则进行第二步。至于线程和进程的关系，[这个回答][B1]非常形象。


对于第二步的原理，可以参考 [prctl 的 PR_SET_CHILD_SUBREAPER 参数](http://man7.org/linux/man-pages/man2/prctl.2.html) 里的描述。
prctl 是 linux 内核暴露的函数，用来查看或修改进程和线程的信息。`PR_SET_CHILD_SUBREAPER` 可以给某个进程标识为 `child_subreaper`，它有这么一段说明：

> When a process is marked as a child subreaper, all of the children
  that it creates, and their descendants, will be marked as
  having a subreaper.

翻译即：当一个进程被标记为 `child_subreaper`，这个进程所创建的所有子进程，包括子进程的子进程，都将被标记拥有一个 subreaper。

那么标记 subreaper 有什么作用呢？

> Upon termination of a process that is orphaned (i.e., its immediate parent has already terminated)
  and marked as having a subreaper, the nearest still living ancestor subreaper will receive a SIGCHLD
  signal and be able to wait(2) on the process to discover its termination status.

也就是说：当一个进程成为了孤儿进程，并且被标记为拥有一个 subreaper。那么会沿着它的进程树向祖先进程找一个最近的是 `child_subreaper` 并且运行着的进程，这个进程将会接管这个孤儿进程。

如果第二步也没有找到，则进行第三步，即使用 pid 为 1 的进程来接管孤儿进程。

而 init 进程通常第一个启动的进程，其他所有进程都是 init 的子进程，所以一般来说最后所有孤儿进程都将被 init 进程接管。
举个特殊情况的例子，比如使用 docker 执行 `docker run --name ubuntu -d ubuntu /bin/bash -c 'sleep 1000'`（这里使用 ubuntu 官方镜像），然后你进入容器中执行 `ps` 就会发现 pid 为 1 的进程是 sleep。

不过也可以做到人为创建一个进程，将它标记为 `child_subreaper`，使其接管其创建的所有孤儿进程，从而不必让 init 进程接管。（具体实现，可以参考 [krallin/tini][]）


孤儿进程被接管的流程大致就是这样。

## 僵尸进程的危害与应对

当子进程退出时，没有被父进程通过 wait/waitpid 来回收的话，该子进程就变成了僵尸进程（zombie process）。
僵尸进程虽然已经释放了大部分它占用的文件，和占用的内存，但仍有少部分信息仍然在占用，比如进程号、进程的退出状态、资源占用信息列表。
它仍然会给系统带来负担。有可能导致不能创建新进程。

所以要避免产生僵尸进程，主要要做的是在父进程上，保证不忽略 SIGCHLD 信号，用 wait/waitpid 来等待子进程结束之类的。
然而 docker 有一些坑，比如[《Docker and the PID 1 zombie reaping problem》][B3] 就是很典型的一例。
这篇文章的作者，也写了一个应对方法：[phusion/baseimage-docker][]，其中自带了它自己的 init 系统，用来保证在容器内部产生的孤儿进程一定会被接管。

当然，你也可以使用其他轻量级的 init 系统：

- [Yelp/dumb-init][]
- [krallin/tini][]

## 结论(Conclusion)

> 如果容器中产生了孤儿进程，谁来接管这个进程？

答案是容器中 pid 为 1 的那个进程。


## 参考(Bibliographies)
- [Stackoverflow - Linux - Threads and Process][B1]
- [Stackoverflow - process re-parenting: controlling who is the new parent][B2]
- [Phusion - Docker and the PID 1 zombie reaping problem][B3]
- [InfoQ - dumb-init：一个 Docker 容器初始化系统][B4]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://stackoverflow.com/a/9306150/4622308
[B2]: http://stackoverflow.com/questions/6476452/process-re-parenting-controlling-who-is-the-new-parent
[B3]: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
[B4]: http://www.infoq.com/cn/news/2016/01/dumb-init-Docker

[Yelp/dumb-init]: https://github.com/Yelp/dumb-init
[krallin/tini]: https://github.com/krallin/tini
[phusion/baseimage-docker]: https://github.com/phusion/baseimage-docker
