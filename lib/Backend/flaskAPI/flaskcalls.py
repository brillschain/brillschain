# from supabaseWorks import *
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import geopy.geocoders


app = Flask(__name__)
CORS(app)

# @app.route('/api/post_data', methods=['POST'])
# def upload_json():
#     try:
#         data = request.get_json()
#         dest = data['path']
#         print(data)
#         json_file_path = dest+'/jsonFile'
#         print(json_file_path)

#         json_string = json.dumps(data, indent=4)
#         with open("../../sample.json", "w") as outfile:
#             outfile.write(json_string)

#         dbwork = SupabasedDb()
#         print('dbvsdh')
#         dbwork.uploadJsonFile("../../sample.json", json_file_path)
#         print('uploaded in supabase')
#         return jsonify({'message': 'Data received successfully and updated on supabase'})

    # except Exception as e:
    #     print(e)
    #     return jsonify({'error': str(e)})

@app.route('/api/dam', methods=['GET'])
def dsfisdfh():
    return {'hi':'bye'}

@app.route('/api/post_pin', methods=['POST'])
def find_pin_cordinates():
    try:
        data = request.get_json()
        # {'pin':3737468}
        pin = data['pin']

        geolocator = geopy.geocoders.Nominatim(user_agent="my_App4")      ## This api may give null or negative cordinates
                                                                         ## Also consider the fact that user_agent
                                                                         # transaction requests are limiter
        location = geolocator.geocode(str(pin))

        lat, long = location.latitude, location.longitude
        print(lat, long)
        loc = []
        j = 0
        for i in str(location).split(','):
            if j==2:
                break
            if i.strip().isnumeric():
                print(i)
                continue
            loc.append(i)
            j+=1

        final_loc = " ".join(loc)

        return jsonify({'latitude': lat, 'longitude': long, 'location': final_loc})
        # return jsonify(location)
        # print(location.latitude, location.longitude)
        return {}
    except Exception as e:
        print(e)
        return jsonify({'error': str(e)})


# @app.route('/api/post_address', methods=['POST'])
# def find_pin_address():
#     try:
#         data = request.get_json()
#         # {'pin':3737468}
#         pin = data['pin']
#         geolocator = Nominatim(user_agent="my_geocoder1")
# # Use geocode with a string query
#         location = geolocator.geocode(pin, addressdetails=True)
#         print(location)
#         return jsonify({'address':location})


#     except Exception as e:
#         print(e)
#         return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True, port=5001)
