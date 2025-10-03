import 'dart:convert';
import 'dart:io';
import 'package:hajj_and_umrah/views/Emergency_Contact/Location.dart';
import 'package:http/http.dart' as http;

class APiHelper {
  // set url of server
  String base_url = 'http://192.168.8.104:5000/';

  Future<int> SignupPerson(String name, String email, String password) async {
    try {
      String url = base_url + "SignupPerson";
      Uri uri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      //request.fields.addAll({"nic":nic});
      request.fields["FULL_NAME"] = name;
      request.fields["EMAIL_ADDRESS"] = email;
      request.fields["PASSWORD"] = password;
      // USER FOR IMAGE
      // http.MultipartFile imgfile =
      //     await http.MultipartFile.fromPath("P_Image", image.path);
      // request.files.add(imgfile);
      var response = await request.send();
      print(response);
      return response.statusCode;
    } catch (Exception) {
      print('$Exception');
      return 500;
    }
  }

  Future<Map<String, dynamic>> SendOtp(String email) async {
    try {
      String url = "$base_url/send_otp"; // Add your base URL
      Uri uri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      // Add the email field
      request.fields["email"] = email;

      // Send the request and get the response
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Convert the response body to a string
        String responseBody = await response.stream.bytesToString();

        // Parse the response body to JSON
        Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Return the parsed response data
        return responseData;
      } else {
        // Handle unsuccessful request
        return {
          "error": "Failed to send OTP",
          "statusCode": response.statusCode
        };
      }
    } catch (e) {
      print("Exception: $e");
      return {"error": "An error occurred while sending OTP"};
    }
  }

  Future<int> uploadChildpic(int cid, File image) async {
    try {
      String url = base_url + "Citizen/UploadChildPic";
      Uri uri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      //request.fields.addAll({"nic":nic});
      request.fields["cid"] = cid.toString();
      http.MultipartFile imgfile =
          await http.MultipartFile.fromPath("image", image.path);
      request.files.add(imgfile);
      var response = await request.send();
      return response.statusCode;
    } catch (Exception) {
      print('$Exception');
      return 500;
    }
  }

  Future<Map<String, dynamic>> loginPerson(
      String email, String password) async {
    String url = base_url + "LoginPerson";
    Uri uri = Uri.parse(url);
    http.MultipartRequest request = http.MultipartRequest('GET', uri);
    request.fields["EMAIL_ADDRESS"] = email;
    request.fields["PASSWORD"] = password;

    // Send the request and get the response
    var response = await request.send();

    // Check the response status code
    int statusCode = response.statusCode;

    // Convert the response body to a string
    String responseBody = await response.stream.bytesToString();

    // Return both status code and parsed response data
    return {
      "statusCode": statusCode,
      "responseData": statusCode == 200
          ? jsonDecode(responseBody)
          : {"error": "Failed to LOGIN"}
    };
  }

  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    String url = base_url + "GetAllDoctors";

    Uri uri = Uri.parse(url);
    var client = http.Client();

    try {
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Access the "doctors" list from the response
        List<dynamic> jsonData = jsonResponse['doctors'];

        // Convert the data to a list of maps
        List<Map<String, dynamic>> dataList = jsonData.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return dataList;
      } else {
        // If the response status code is not 200, throw an error
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    } finally {
      client.close();
    }
  }

  Future<List<Map<String, dynamic>>> getNearestHospitals() async {
    String url = base_url + "nearest_hospitals";
    Uri uri = Uri.parse(url);
    var client = http.Client();

    try {
      final position = await getUserLocation();

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
      } else {
        throw Exception('Failed to fetch nearest hospitals');
      }
    } catch (e) {
      throw Exception('Error fetching nearest hospitals: $e');
    } finally {
      client.close();
    }
  }

  // Future<List<Map<String, dynamic>>> getAllHospital() async {
  //   String url = base_url + "GetAllHospitals";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();

  //   try {
  //     var response = await client.get(uri);

  //     if (response.statusCode == 200) {
  //       // Decode the JSON response
  //       Map<String, dynamic> jsonResponse = json.decode(response.body);

  //       // Access the "doctors" list from the response
  //       List<dynamic> jsonData = jsonResponse['hospital'];

  //       // Convert the data to a list of maps
  //       List<Map<String, dynamic>> dataList = jsonData.map((item) {
  //         return Map<String, dynamic>.from(item);
  //       }).toList();

  //       return dataList;
  //     } else {
  //       // If the response status code is not 200, throw an error
  //       throw Exception('Failed to load hospital');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching hospital: $e');
  //   } finally {
  //     client.close();
  //   }
  // }

  Future<List<Map<String, dynamic>>> getAllEmergency() async {
    String url = base_url + "GetAllEmergency";

    Uri uri = Uri.parse(url);
    var client = http.Client();

    try {
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Access the "doctors" list from the response
        List<dynamic> jsonData = jsonResponse['emergency'];

        // Convert the data to a list of maps
        List<Map<String, dynamic>> dataList = jsonData.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return dataList;
      } else {
        // If the response status code is not 200, throw an error
        throw Exception('Failed to load hospital');
      }
    } catch (e) {
      throw Exception('Error fetching hospital: $e');
    } finally {
      client.close();
    }
  }

  Future<List<Map<String, dynamic>>> getNearestClinics() async {
    String url = base_url + "nearest_clinics";
    Uri uri = Uri.parse(url);
    var client = http.Client();
    try {
      final position = await getUserLocation();

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
      } else {
        throw Exception('Failed to fetch nearest clinics');
      }
    } catch (e) {
      throw Exception('Error fetching nearest clinics: $e');
    } finally {
      client.close();
    }
  }

  // Future<List<Map<String, dynamic>>> getAllClinic() async {
  //   String url = base_url + "GetAllClinic";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();

  //   try {
  //     var response = await client.get(uri);

  //     if (response.statusCode == 200) {
  //       // Decode the JSON response
  //       Map<String, dynamic> jsonResponse = json.decode(response.body);

  //       // Access the "doctors" list from the response
  //       List<dynamic> jsonData = jsonResponse['clinics'];

  //       // Convert the data to a list of maps
  //       List<Map<String, dynamic>> dataList = jsonData.map((item) {
  //         return Map<String, dynamic>.from(item);
  //       }).toList();

  //       return dataList;
  //     } else {
  //       // If the response status code is not 200, throw an error
  //       throw Exception('Failed to load hospital');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching hospital: $e');
  //   } finally {
  //     client.close();
  //   }
  // }

  // Future<List<String>> getChildImagesList(int cid) async {
  //   String url = base_url + "getChildImage/$cid";
  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<String> imagesList = [];

  //     for (var item in jsonData) {
  //       String imageUrl = item;
  //       String imageName = imageUrl.split('\\').last;
  //       imageUrl = base_url + "images/" + imageName;

  //       imagesList.add(imageUrl);
  //     }

  //     return imagesList;
  //   } else {
  //     throw Exception('Failed to load missing child images');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getFoundReport() async {
  //   String url = base_url + "FoundChilds";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getAdoptableChild() async {
  //   String url = base_url + "get_Adoptable_Childs";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> SearchAdoptiveChild(
  //     String searchval) async {
  //   String url = base_url + "Search_Adopted_Childs/$searchval";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getMissingRequestPolice() async {
  //   String url = base_url + "MissingChilds";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getFoundRequestPolice() async {
  //   String url = base_url + "foundrequestpolice";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // // eidi child adoption requests
  // Future<List<Map<String, dynamic>>> getAdoptionRequest() async {
  //   String url = base_url + "adoptiverequest";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load Adopted Request');
  //   }
  // }

  // // History or own reports
  // Future<List<Map<String, dynamic>>> getOwnMissingReport(String cnic) async {
  //   String url = base_url + "OwnMissingReport?cnic=$cnic";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getOwnFoundReport(String cnic) async {
  //   String url = base_url + "OwnFoundReport?cnic=$cnic";

  //   Uri uri = Uri.parse(url);
  //   var client = http.Client();
  //   var response = await client.get(uri);
  //   client.close();

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = json.decode(response.body);
  //     List<Map<String, dynamic>> dataList = [];
  //     for (var item in jsonData) {
  //       Map<String, dynamic> record = (Map<String, dynamic>.from(item));
  //       if (record.containsKey("Image") && record["Image"] is String) {
  //         String imageUrl = record["Image"];
  //         String imageName = imageUrl.split('\\').last;
  //         imageUrl = base_url + "images/" + imageName;
  //         record["imageUrl"] = imageUrl;
  //         dataList.add(record);
  //       }
  //     }
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load missing report');
  //   }
  // }
}
