#
# Configures EE Subsystem
#
# @ param deployments hash of the Global EE Deployments Attributes - 
# @ param default_bindings hash of the Global EE Default Bindings Attributes
#

define wildfly::subsystem::ee(
  Struct[{annotation-property-replacement => Optional[Boolean],
          ear-subdeployments-isolated => Optional[Boolean],
          jboss-descriptor-property-replacement => Optional[Boolean],
          spec-descriptor-property-replacement => Optional[Boolean],
          global-modules => Optional[Array]}] $deployments                 = undef,
  Struct[{context-service => Optional[String],
          datasource => Optional[String],
          jms-connection-factory => Optional[String],
          managed-executor-service => Optional[String],
          managed-scheduled-executor-service => Optional[String],
          managed-thread-factory => Optional[String]}] $default_bindings   = undef,
){

  if $deployments {
    wildfly::resource{'/subsystem=ee':
      content => $deployments,
    }
  }
  if $default_bindings {
    wildfly::resource {'/subsystem=ee/service=default-bindings':
      content => $default_bindings,
    }
  }
}
