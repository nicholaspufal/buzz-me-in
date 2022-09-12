install:
	@brew tap twilio/brew && brew install twilio
	@twilio plugins:install @twilio-labs/plugin-serverless

deploy.dev: install
	@twilio serverless:deploy

deploy: install
	@twilio serverless:deploy --production
