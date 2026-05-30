from glob import glob
import json
import boto3
import os
import logging
import shutil
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    """
    Lambda function to copy files from S3 to the root of EFS
    """
    try:
        bucket_name = event.get("s3_bucket_name") or os.environ.get('S3_BUCKET_NAME')
        efs_mount_path = '/mnt/efs'

        if os.path.exists(efs_mount_path):
            logger.info(f"Cleaning up EFS target directory: {efs_mount_path}")
            for item in glob(os.path.join(efs_mount_path, '*')):
                if os.path.isdir(item):
                    shutil.rmtree(item)
                else:
                    os.remove(item)

        if not bucket_name:
            raise ValueError("S3_BUCKET_NAME environment variable is not set")

        logger.info(f"Starting file copy from S3 bucket: {bucket_name}")
        logger.info(f"EFS mount path: {efs_mount_path}")

        # Ensure EFS mount directory exists
        os.makedirs(efs_mount_path, exist_ok=True)

        response = s3_client.list_objects_v2(Bucket=bucket_name)

        if 'Contents' not in response:
            logger.info("No files found in S3 bucket")
            return {
                'statusCode': 200,
                'body': json.dumps('No files to process')
            }

        for obj in response['Contents']:
            key = obj['Key']
            local_path = os.path.join(efs_mount_path, *key.split('/'))

            logger.info(f"Downloading {key} to {local_path}")
            os.makedirs(os.path.dirname(local_path), exist_ok=True)
            s3_client.download_file(bucket_name, key, local_path)

        logger.info("File copy completed successfully")
        return {
            'statusCode': 200,
            'body': json.dumps('Files copied successfully to EFS')
        }

    except ClientError as e:
        logger.error(f"S3 error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'S3 error: {str(e)}')
        }

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
