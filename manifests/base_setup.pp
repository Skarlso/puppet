# include apt
 
class base::basics {
        $packages = ['git', 'subversion', 'mc', 'vim', 'maven', 'gradle']
 
        exec { "update":
                command =&gt; "/usr/bin/apt-get update",
        }
 
        package { $packages:
                ensure =&gt; installed,
                require =&gt; Exec["update"],
        }
 
}
 
class base::skype {
        exec { "add-arc":
                command =&gt; "/usr/bin/dpkg --add-architecture i386",
        }
 
        exec { "add-repo-skype":
                command =&gt; "/usr/bin/add-apt-repository \"deb http://archive.canonical.com/ \$(lsb_release -sc) partner\"",
                require =&gt; Exec['add-arc'],
        }
 
        exec { "update-and-install":
                command =&gt; "/usr/bin/apt-get update &amp;&amp; /usr/bin/apt-get install skype",
                require =&gt; Exec['add-repo-skype'],
        }
}
 
class base::java8 {
        # Automatically does an update afterwards
        # apt::ppa { 'ppa:webupd8team/java': }
        exec { "add-repo-java":
                command =&gt; "/usr/bin/add-apt-repository -y \"ppa:webupd8team/java\" &amp;&amp; /usr/bin/apt-get update"
        }
 
        exec { "set-accept":
                command =&gt; "/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections &amp;&amp; /bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections",
                require =&gt; Exec['add-repo-java'],
        }
 
        exec { "install":
                command =&gt; "/usr/bin/apt-get install -y oracle-java8-installer",
                require =&gt; Exec['set-accept'],
        }
 
        exec { "setup_home":
                command =&gt; "/bin/echo \"export JDK18_HOME=/usr/lib/jvm/java-8-oracle/\" &gt;&gt; /etc/environment",
                require =&gt; Exec['install'],
        }
}
 
include base::basics
include base::skype
include base::java8
