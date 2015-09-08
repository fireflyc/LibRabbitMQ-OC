Pod::Spec.new do |s|
  s.name                  = 'LibRabbitMQ-OC'
  s.version               = 'v1.0.0'
  s.homepage              = 'https://github.com/fireflyc/LibRabbitMQ-OC'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'fireflyc' => 'fireflyc@126.com' }
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.source                = { :git => 'https://github.com/fireflyc/LibRabbitMQ-OC.git', :tag => 'master' }
  s.source_files          = 'LibRabbitMQ-OC/Classes'
  s.requires_arc          = true
  s.summary               = 'RabbitMQ Objective-C Client'
  s.description  = <<-DESC
	  # LibRabbitMQ-OC
	  RabbitMQ Objective C Client
	  DESC
end
