import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import hudson.security.HudsonPrivateSecurityRealm
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.CLI
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

println "--> creating private authentication strategy"
HudsonPrivateSecurityRealm hudsonRealm = new HudsonPrivateSecurityRealm(false)

println "--> creating local user 'admin'"
hudsonRealm.createAccount('admin', 'admin')

println "--> creating crumb issuer"
DefaultCrumbIssuer defaultCrumbIssuer = new DefaultCrumbIssuer(true)
instance.crumbIssuer = defaultCrumbIssuer
instance.setSecurityRealm(hudsonRealm)

println "--> enabling slave access control mechanism"
instance.getInjector().getInstance(AdminWhitelistRule.class)
        .setMasterKillSwitch(false)

println "--> setting full control once logger authorization strategy"
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.allowAnonymousRead = false
instance.setAuthorizationStrategy(strategy)

println "--> disabling CLI remote access"
CLI.get().setEnabled(false)

instance.save()
