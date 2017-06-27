import jenkins.model.*
import java.util.logging.Logger
import jenkins.slaves.JnlpSlaveAgentProtocol4

def logger = Logger.getLogger("")
def instance = Jenkins.getInstance()
def current_slaveport = instance.getSlaveAgentPort()
def defined_slaveport = 50000

if (current_slaveport != defined_slaveport) {
    instance.setSlaveAgentPort(defined_slaveport)
    logger.info("Slaveport set to " + defined_slaveport)
    instance.setAgentProtocols([JnlpSlaveAgentProtocol4.name].toSet())
}

instance.save()
