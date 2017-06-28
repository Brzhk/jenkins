def instance = Jenkins.getInstance()

def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setAdminAddress("Matthieu Bertin <berzehk@gmail.com>")
jenkinsLocationConfiguration.save()

instance.save()
