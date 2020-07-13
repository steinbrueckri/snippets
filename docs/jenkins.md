# Jenkins

## How to stop an unstoppable zombie job on Jenkins without restarting the server

I had also the same problem and fix it via Jenkins Console. Go to "Manage Jenkins" > "Script Console" and run a script:

```java
Jenkins.instance.getItemByFullName("JobName").getBuildByNumber(JobNumber).finish(hudson.model.Result.ABORTED, new java.io.IOException("Aborting build"));
```

You'll have just specify your JobName and JobNumber.

[https://stackoverflow.com/questions/14456592/how-to-stop-an-unstoppable-zombie-job-on-jenkins-without-restarting-the-server](https://stackoverflow.com/questions/14456592/how-to-stop-an-unstoppable-zombie-job-on-jenkins-without-restarting-the-server)
