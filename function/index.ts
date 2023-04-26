import { APIGatewayEvent, APIGatewayProxyResult, Context } from 'aws-lambda'

export const handler = async (event: APIGatewayEvent, context: Context): Promise<APIGatewayProxyResult> => {
  console.info('EVENT\n' + JSON.stringify(event, null, 2))

  // The local aws-lambda-rie will pass data straight to the event but the real one to event.body
  const data = JSON.parse(event.body || JSON.stringify(event))
  console.info('DATA\n' + JSON.stringify(data, null, 2))

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Hello from Lambda!',
    }),
  }
}
