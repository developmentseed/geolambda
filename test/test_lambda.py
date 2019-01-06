from unittest import TestCase
import imp

lambda_function = imp.load_source('lambda_function', 'lambda/lambda_function.py')


class TestLambda(TestCase):

    payload = {
        'filename': 'https://landsat-pds.s3.amazonaws.com/L8/001/002/LC80010022016230LGN00/LC80010022016230LGN00_B3.TIF'
        #'filename': 's3://landsat-pds/L8/001/002/LC80010022016230LGN00/LC80010022016230LGN00_B3.TIF'
    }

    def test_load_lambda(self):
        """ Test the lambda handler is loaded """
        self.assertTrue(hasattr(lambda_function, 'lambda_handler'))

    def test_run_lambda(self):
        """ Run the lambda handler with test payload """
        result = lambda_function.lambda_handler(self.payload, None)
        self.assertEqual(len(result), 4)
