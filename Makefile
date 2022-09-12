aws.deploy:
	@cd aws-lambda-function && make deploy

aws.update:
	@cd aws-lambda-function && make update

twilio.deploy:
	@cd twilio-function && make deploy
