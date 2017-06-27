import jenkins.model.Jenkins

// For each project
for (item in Jenkins.instance.items) {
    // check that job is not building
    if (!item.isBuilding()) {
        println("Wiping out workspace of job " + item.name)
        item.doDoWipeOutWorkspace()
    } else {
        println("Skipping job " + item.name + ", currently building")
    }
}
