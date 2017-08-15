from unittest import TestCase
import imp

lambda_handler = imp.load_source('lambda_handler', 'lambda/lambda_handler.py')


class TestLambda(TestCase):

    payload = {
        'filename': 's3://landsat-pds/L8/001/002/LC80010022016230LGN00/LC80010022016230LGN00_B3.TIF'
    }

    def test_load_lambda(self):
        """ Test the lambda handler is loaded """
        self.assertTrue(hasattr(lambda_handler, 'handler'))

    def test_run_lambda(self):
        """ Run the lambda handler with test payload """
        result = lambda_handler.handler(self.payload, None)
        self.assertEqual(len(result), 4)
