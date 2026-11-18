@description('Alert rule name.')
param name string
@description('Existing virtual machine resource ID.')
param virtualMachineId string
@description('Existing action group resource ID for notifications.')
param actionGroupId string
@description('Average CPU percentage threshold.')
@minValue(1)
@maxValue(100)
param threshold int = 80

resource alert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: 'global'
  properties: {
    description: 'Sustained VM CPU utilization'
    severity: 2
    enabled: true
    scopes: [virtualMachineId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [{
        name: 'CpuHigh'
        metricName: 'Percentage CPU'
        metricNamespace: 'Microsoft.Compute/virtualMachines'
        operator: 'GreaterThan'
        threshold: threshold
        timeAggregation: 'Average'
        criterionType: 'StaticThresholdCriterion'
      }]
    }
    actions: [{ actionGroupId: actionGroupId }]
    autoMitigate: true
  }
}

output id string = alert.id
