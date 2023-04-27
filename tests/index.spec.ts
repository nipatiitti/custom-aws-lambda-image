import chai from 'chai'
import chaiHttp from 'chai-http'
import { describe } from 'mocha'

chai.use(chaiHttp)
chai.should()

const baseUrl = 'http://localhost:8080/2015-03-31/functions/function/invocations'

describe('it-runs', () => {
  it('Should return 200', () => {
    chai
      .request(baseUrl)
      .get('/')
      .end((err, res) => {
        res.should.have.status(200)
      })
  })
})
