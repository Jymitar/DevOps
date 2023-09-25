import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

hudsonRealm.createAccount("jmy","jmypass")
instance.setSecurityRealm(hudsonRealm)
instance.save()