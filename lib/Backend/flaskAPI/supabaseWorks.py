import os
from supabase import *
class SupabasedDb:
    Client=None
    def __init__(self):

        APIURL= 'https://pgmargyrgwnfydjnszma.supabase.co/'
        APIKEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBnbWFyZ3lyZ3duZnlkam5zem1hIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkwMzI3MjQsImV4cCI6MjAxNDYwODcyNH0.3gVvHMZnR1NxtQ1V9_t69qqZKQ408aC84CjWqygNF4I'
        try:
            supbaseClient = create_client(APIURL, APIKEY)
            self.Client = supbaseClient
            print(supbaseClient)
        except Exception as e:
            print(e)
    
    def uploadJsonFile(self,filepath, path_on_supastorage):
        with open(filepath, 'rb') as f:
            self.Client.storage.from_("myBucket").upload(file=f,path=path_on_supastorage, file_options={"content-type": "application/json"})

    def get_data(self, filename):
        response = self.Client.storage.from_('myBucket').get_public_url(filename)
        print('obtained response')
        return response