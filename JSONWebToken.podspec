Pod::Spec.new do |spec|
  spec.name = 'JSONWebToken'
  spec.version = '2.2.1'
  spec.summary = 'Swift library for JSON Web Tokens (JWT).'
  spec.homepage = 'https://github.com/kylef/JSONWebToken.swift'
  spec.license = { :type => 'BSD', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'kyle@fuller.li' }
  spec.source = { :git => 'https://github.com/kylef/JSONWebToken.swift.git' }
  spec.source_files = 'Sources/JWT/*.swift'
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '3.0'
  spec.requires_arc = true
  spec.module_name = 'JWT'
  spec.exclude_files = ['Sources/JWT/HMACCryptoSwift.swift']

  spec.swift_version = '4.2'

  if ARGV.include?('lint')
    spec.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => Dir.pwd,
    }
  else
    spec.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/JSONWebToken/',
    }
  end

	spec.script_phase = {
		:name => 'CommonCrypto',
		:script => 'COMMON_CRYPTO_DIR="${SDKROOT}/usr/include/CommonCrypto"
		if [ -f "${COMMON_CRYPTO_DIR}/module.modulemap" ]
			then
			echo "CommonCrypto already exists, skipping"
			else
			# This if-statement means we will only run the main script if the
			# CommonCrypto.framework directory doesn not exist because otherwise
			# the rest of the script causes a full recompile for anything
			# where CommonCrypto is a dependency
			# Do a "Clean Build Folder" to remove this directory and trigger
			# the rest of the script to run
			FRAMEWORK_DIR="${BUILT_PRODUCTS_DIR}/CommonCrypto.framework"
			if [ -d "${FRAMEWORK_DIR}" ]; then
				echo "${FRAMEWORK_DIR} already exists, so skipping the rest of the script."
				exit 0
				fi
				mkdir -p "${FRAMEWORK_DIR}/Modules"
				echo "module CommonCrypto [system] {
				header \"${SDKROOT}/usr/include/CommonCrypto/CommonCrypto.h\"
				export *
				}" >> "${FRAMEWORK_DIR}/Modules/module.modulemap"
				ln -sf "${SDKROOT}/usr/include/CommonCrypto" "${FRAMEWORK_DIR}/Headers"
				fi',
		:execution_position => :before_compile
	}
end
