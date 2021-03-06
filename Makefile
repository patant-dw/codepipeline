# AWS CONFIG
AWS_REGION = eu-west-1
# PIPELINE CONFIG
PIPELINE_ARTIFACT_BUCKET_NAME = patant-time-pipe
deploy-pipeline:
	$(eval STACKNAME=patantpipeline)
	aws cloudformation create-stack \
	       	--stack-name $(STACKNAME) \
		--parameters ParameterKey=PipeLineDataBucketName,ParameterValue=$(PIPELINE_ARTIFACT_BUCKET_NAME) \
		--template-body file://cloudformationPipeline.yml \
		--capabilities CAPABILITY_IAM \
		--region $(AWS_REGION)
	aws cloudformation wait stack-create-complete \
		--stack-name=$(STACKNAME) \
		--region $(AWS_REGION)

test-patanttime:
	@echo "Running unit tests for patanttime"
	cd functions/patanttime/src && \
	yarn install && \
	yarn test

build-patanttime:
	@echo "Building patanttime"
	cd functions/patanttime/src && \
	yarn install --production && \
	cd ../deploy && \
	aws cloudformation package \
		--template-file cloudformationSAM.yml \
		--s3-bucket $(PIPELINE_ARTIFACT_BUCKET_NAME) \
		--s3-prefix patanttime \
		--output-template-file patanttimeSamTemplate.yaml \
		--region $(AWS_REGION)

deploy:
	@echo "deploy"
