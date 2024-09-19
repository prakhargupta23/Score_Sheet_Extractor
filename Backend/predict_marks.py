import requests
import base64
from serpapi import GoogleSearch
import json
import sys
import io
import time
import cv2
import os
from dotenv import load_dotenv, dotenv_values




class Predict :

    async def execute(self):
        self.resize()
        dict = self.predict()
        print(dict)
        # print('a')
        return dict



    def delete_file_from_github(self,image_path, github_repo, github_username, github_token):
        # Prepare headers
        headers = {
            'Authorization': f'token {github_token}',
            'Content-Type': 'application/json',
            'Accept': 'application/vnd.github.v3+json'
        }

        # Construct URL
        url = f'https://api.github.com/repos/{github_username}/{github_repo}/contents/{image_path}'

        # Make the request to get file details
        response = requests.get(url, headers=headers)
        
        # Check if the file exists
        if response.status_code == 404:
            print("File not found.")
            return
        elif response.status_code != 200:
            print(f"Failed to retrieve file details. Status code: {response.status_code}")
            print(response.text)
            return

        # Extract file details
        file_details = response.json()
        file_sha = file_details.get('sha')

        if not file_sha:
            print("Failed to extract SHA from file details.")
            return

        # Prepare data
        data = {
            'message': 'Delete image',
            'sha': file_sha
        }

        # Make the DELETE request
        delete_response = requests.delete(url, json=data, headers=headers)

        if delete_response.status_code == 200:
            print("File deleted successfully.")
        else:
            print(f"Failed to delete file. Status code: {delete_response.status_code}")
            print(delete_response.text)


    def resize(self):
        img = cv2.imread("10_perspective_corrected.jpg")
        rows, cols, _ = img.shape
        x = int(rows/12)
        y = int(cols/2)

        cut_image = img[1*x:12*x, y:2*y]
        resized_image = cv2.resize(cut_image, (120, 600))
        print('resized successfully')
        cv2.imwrite("resized_image.jpg", resized_image)

    def upload_image_to_github(self, image_path, github_repo, github_username, github_token):
        # Prepare headers
        headers = {
            'Authorization': f'token {github_token}',
            'Content-Type': 'application/json',
            'Accept': 'application/vnd.github.v3+json'
        }

        # Construct URL to check if file exists
        url = f'https://api.github.com/repos/{github_username}/{github_repo}/contents/{image_path}'

        # Make a GET request to check if file exists
        response = requests.get(url, headers=headers)

        # Read image as binary
        with open(image_path, 'rb') as file:
            content = file.read()

        encoded_content = base64.b64encode(content).decode('utf-8')

        # Prepare data
        data = {
            'message': 'Upload or update image',
            'content': encoded_content
        }

        # If file exists, get sha for update
        if response.status_code == 200:
            file_details = response.json()
            file_sha = file_details.get('sha')
            if file_sha:
                data['sha'] = file_sha

        # Make the PUT request to create or update the file
        response = requests.put(url, json=data, headers=headers)

        if response.status_code in [200, 201]:
            print("Image uploaded or updated successfully.")
        else:
            print(f"Failed to upload or update image. Status code: {response.status_code}")
            print(response.text)

    def predict(self):
        load_dotenv()
        image_path = 'resized_image.jpg'
        github_repo = 'Images'
        github_username = 'PrajwalSugandhi'
        github_token = os.getenv("GITHUBAPI_KEY")

        self.upload_image_to_github(image_path, github_repo, github_username, github_token)
        
        # print('Next')
        # sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
        # print('Next-1.2')
        
        params = {
            'api_key': os.getenv("SERPAPI_KEY"),
            'engine': 'google_lens',
            'url': f'https://raw.githubusercontent.com/PrajwalSugandhi/Images/main/{image_path}',
            'hl': 'en',
            'no_cache': 'true',
        }
        # print('Next-1.5')

        search = GoogleSearch(params)                   
        google_lens_results = search.get_dict()

        # print('Next-2')
        results_j = json.dumps(google_lens_results, indent=2, ensure_ascii=False)
        # return results_j
        results = json.loads(results_j)
        data_dict = {}
        # print(results)
        # print('Next-3')

        for i in range(0,13):
            if 'text_results' in results:
                try:
                    if(results['text_results'][i]['text'] == '1/2'):
                        data_dict[i+1] = 0.5
                    else:    
                        data_dict[i+1] = float(results['text_results'][i]['text'])
                    # print(results['text_results'][i]['text'])
                except (IndexError , ValueError) as e:
                    # data_dict[i+1] = 0.0
                    print(e)

                
            else:
                
                print('no result')


        # json_data = json.dumps(data_dict, indent=4)
        # self.delete_file_from_github(image_path, github_repo, github_username, github_token)
        return data_dict
