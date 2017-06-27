import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false as Boolean
def initialized = false as Boolean

def pluginParameter="ace-editor ant antisamy-markup-formatter authentication-tokens aws-java-sdk blueocean-autofavorite blueocean-commons blueocean-config blueocean-dashboard blueocean-display-url blueocean-events blueocean-git-pipeline blueocean-github-pipeline blueocean-i18n blueocean-jwt blueocean-personalization blueocean-pipeline-api-impl blueocean-pipeline-editor blueocean-pipeline-scm-api blueocean-rest-impl blueocean-rest blueocean-web blueocean bouncycastle-api branch-api cloudbees-folder config-file-provider credentials-binding credentials display-url-api docker-commons docker-workflow durable-task external-monitor-job favorite git-client git-server git github-api github-branch-source github-organization-folder github handlebars icon-shim jackson2-api javadoc jquery-detached junit ldap mailer matrix-auth matrix-project metrics momentjs pam-auth pipeline-aggregator-view pipeline-aws pipeline-build-step pipeline-github-lib pipeline-graph-analysis pipeline-input-step pipeline-maven pipeline-milestone-step pipeline-model-api pipeline-model-declarative-agent pipeline-model-definition pipeline-model-extensions pipeline-multibranch-defaults pipeline-rest-api pipeline-stage-step pipeline-stage-tags-metadata pipeline-stage-view pipeline-utility-steps plain-credentials pubsub-light scm-api script-security sse-gateway ssh-credentials structs token-macro variant webhook-step windows-slaves workflow-aggregator workflow-api workflow-basic-steps workflow-cps-global-lib workflow-cps workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support"
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
uc.updateAllSites()

plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
      logger.info("Installing " + it)
    	plugin.deploy()
      installed = true
    }
  }
}

if (installed) {
  logger.info("Plugins installed, initializing a restart!")
  instance.save()
  instance.doSafeRestart()
}
