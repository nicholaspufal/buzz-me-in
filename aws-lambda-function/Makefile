docker.build:
	@docker build --no-cache -t buzz-me-in .

docker.run:
	@docker run -it -v $(pwd):/usr/src/app buzz-me-in bash

docker.bundle_install:
	@echo "Installing dependencies..."
	@docker run -it -v $(pwd):/usr/src/app buzz-me-in bundle

deploy.zip: docker.bundle_install
	@echo "Zipping project..."
	@zip -r twilio_webhook.zip twilio_webhook.rb vendor/

deploy: deploy.zip
	@echo "Creating function and deploying to AWS Lambda..."
	@aws lambda create-function \
		--function-name twilio-webhook \
		--runtime ruby2.7 \
		--role $(AWS_ROLE_ARN) \
		--handler twilio_webhook.twilio_postback_handler \
		--environment "Variables={TWILIO_ACCOUNT_SID=$(TWILIO_ACCOUNT_SID),TWILIO_PHONE_NUMBER=$(TWILIO_PHONE_NUMBER),TWILIO_TOKEN=$(TWILIO_TOKEN),DESTINATION_PHONE_NUMBERS='$(DESTINATION_PHONE_NUMBERS)'}" \
		--zip-file fileb://twilio_webhook.zip

update: deploy.zip
	@echo "Deploying to AWS Lambda..."
	@aws lambda update-function-code --function-name twilio-webhook --zip-file fileb://twilio_webhook.zip
