#This script creates a new Unauthorized API Call CloudWatch Metric and Alarm that excludes Macie
#Variables set for SNS-arn and Log Group name
export SNS='cloudtrail_alerts'
export LOGGROUP='aws-cloudtrail-logs'

## Metrics ##
echo "Creating new Unauthorized API Call CloudWatch Metrics....." && sleep 3
# Unauthorized API calls
aws logs put-metric-filter --log-group-name $LOGGROUP --filter-name unauthorized_api_calls_metric  --metric-transformations metricName=unauthorized_api_calls_metric_v2,metricNamespace='CISBenchmark',metricValue=1 --filter-pattern '{ ($.errorCode = "*UnauthorizedOperation") || ($.errorCode = "AccessDenied*") && ($.eventSource != "macie.amazonaws.com") && ($.eventSource != "macie2.amazonaws.com")}'
echo "unauthorized_api_calls_metric = metric created"

## Alarms ##
echo "Creating CloudWatch Alarm......." && sleep 3

# Unauthorized API calls
aws cloudwatch put-metric-alarm --alarm-name unauthorized_api_calls_alarm  --metric-name  'unauthorized_api_calls_metric_v2'  --statistic Sum --period '300' --threshold '1' --comparison-operator 'GreaterThanOrEqualToThreshold' --evaluation-periods 1 --namespace CISBenchmark --treat-missing-data 'notBreaching' --alarm-actions $SNS
echo "unauthorized_api_calls_alarm = alarm created"

