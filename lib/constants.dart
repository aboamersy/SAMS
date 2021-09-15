import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

const kDefaultTextStyle = TextStyle(
  color: Color(0xff31776a),
  fontWeight: FontWeight.bold,
  fontSize: 30,
  fontFamily: ArabicFonts.Cairo,
  package: 'google_fonts_arabic',
);

final kSelectMenuStyle =
    kDefaultTextStyle.copyWith(fontSize: 15, color: Colors.black54);

const String kSessionsRootCollection = '/subjects';

const credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-315719",
  "private_key_id": "edb3b2937b253db1144a1a2e8f76ddb1ef9fb8cd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPMnKJPcXQFO0V\n2kvz2VPcZEDtJGCMjrNzFYDWjy0FGcPUZAEc1vMN2sDBBej4XmKhNYD6UheGaKVE\no1x11fduTCVN81U/cS5LF+2YmnSsNFpmMSVo2Ht8vMjG0bRW03f8EZaYJO4EGIuS\nSyIKZpQfMlMIX1gSEfaM5d2PblgOlt8fYXOyYnQBk/9V+syvLzAjzH0H8CzNhYL6\n81gV5BJWPRBzUgdM9fJah/oTJGQnpqEnsI/A3EjhrYjBRpev2S2zgeZnfc8zFMDK\nWsHrLnt0rNbnufOj8Qan4QZVfYCS2hk5FCbGnTCNQFSqIIwgKT6EsbLVjFjZmOoX\nXQcjdDbTAgMBAAECggEAG/tuqifsYVaU0aOKfWi84XdX/g7bITBxKMTfLQWSFBhv\nhkK+lGQCguenqjR/oEddn52dCRwcGZFkEdnUIK/gZjDPcEXBc2Yi1TkVOUumynju\n5SfpqvgNmVeE8Aud2i9eCsNfU2CCv+KGuvT9qGpDwoDROOtozAFJYFb3mKl+J/NX\nAM4v7wtClqVQ7wfzcV9xe4xAaWrp5jRKpgA97PXi2abj0yBWIJg8dktxlfcKTfEe\nLystOdzbfZRrxFAzUyuvGjC3bfvB1VnisVL3u5r72VAnKE36nJht3qv42/6vBgne\nw0C59uY76NjRU1XoKom7ocL3Pk6ssWfkhQSZLwtiLQKBgQDpwg3hjBUjOiJrW+yN\nmsEoUA8aQKG5cn+DaCFF068mRbWcjbkqMvRUV5XOOm7YDEKpfD92zzAGCWi7p9iz\nW/Yk+0PIoSTjxJe25LBVtZmN4KLOPundhrKAWW3wYBxr4Mv4V/4XPYbVpbcsQc2P\nBx3oxIU0gOHNQKoYojHXFava7wKBgQDi6WncA68pOUCGluc9EeNHCldZO81ebP57\nfniVRxhxRHDAxWeyCnMBs4/7r6hkxCsJcdqIXMBWp5U2vxng7s/w9mBTLUbrfH7l\n7dnxYdQ1utXsb5GR5/Sp8Av3cxwgOs4o1Gm8YXN8V8XfpSsaR1vr5jXsKTwPox3N\nYwexPO0yXQKBgCWu79ftYjb0lznhbsgBK6RZC6Y6xxeDOsUvUzXTg0fTMwzS2AfS\ngQrbt72wM9BGYbS63+xCSEag265sx4VajNq3Wt0MBUtmlOKaCUc36FIz5WsEP2VD\n4qDISe3XQJ2vdpJJdR+//m2Qsm/DB+VHy22LyMGHCV+yTfl8pDY9OyAnAoGBAM7q\nrl+09FuRG6gfn4nu7+PuKCz0/ZdnqMAQWgE2LbHMCU2gNakDIlCg32FRkysgP2aD\nbhX/Dl12v/iGVyDoZLKE2N3AYfWHN2iQdrdI0GyWjVDnhEUa0d7NSPxC+ZjiRvCw\nkiL4cokmuQfx49Y40DfTW8SY7W4M/rY14ePbfSj5AoGAaiKZfIPPgDzCx8BvVnhE\n/DPAF3rh6NDuzoYxHc3xI29DnrfkBiCNxuEXCSVhzWtWWJziaAPFUUWy2uX+XHhZ\naTXJl3Q1CIyhUkoYEwK3foljoHlzwMKQPpNWMf7fVTohHDdXfbiphe3J/Pz5/yle\nHTExezmzV2RzSJeGJqN2ngM=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-315719.iam.gserviceaccount.com",
  "client_id": "118060291214835341785",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-315719.iam.gserviceaccount.com"
}
''';
const spreadsheetId = '1G7zpisIBQMs8ahgAqnr8L-F6_6A5emsyqtUnv7eSRrY';
final firstRow = [
  'المدرس',
  'المادة',
  'التاريخ',
  'الاسم',
  'الرقم الجامعي',
  'السنة',
  'التفقد',
  'نسبة الحضور في الجلسة',
  'نسبة الغياب عن الجلسة',
];
