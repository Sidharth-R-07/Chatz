import 'package:chatz/DataBase/db_Firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../decoration.dart';
import '../widgets/build_usersList.dart';
import '../widgets/drawer.dart';
import '../widgets/search_userlist.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen>
    with WidgetsBindingObserver {
//update app status

  void updateStatus(String status) async {
    final dbProvider = Provider.of<DbFireStore>(context, listen: false);
    dbProvider.updateStatus(
        status: status, currentUserId: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void initState() {
    super.initState();

    updateStatus('Online');

    WidgetsBinding.instance.addObserver(this);

    // checkInternet();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
//app is running

      updateStatus('Online');
    } else if (state == AppLifecycleState.inactive) {
      updateStatus('Offline');
    }
//app is not running
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//variable for search text

  ValueNotifier<String> searchText = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: const MyyDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: deviceHieght*0.05,
              color: Color(logoColor),
            ),
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
          ),
          title: Text(
            'ChatZ',
            style: TextStyle(
                color: Color(logoColor),
                fontWeight: FontWeight.w900,
                fontSize: deviceHieght*0.05,
                letterSpacing: 4),
          ),
         
        ),
        backgroundColor: Color(backgroundColor),
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: deviceHieght*0.01, horizontal: deviceWidth*0.01),
            child: Column(
              children: [
//-------------------------------------search formfield------------------------------
                TextFormField(
                  style:  TextStyle(
                      color: Colors.white,
                      fontSize: deviceHieght*0.02,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1),
                  onChanged: (val) {
                    searchText.value = val;

                    print(searchText);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users',
                    hintStyle:
                         TextStyle(color: Colors.grey, fontSize: deviceHieght*0.02),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(logoColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(width: 2, color: Color(logoColor)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(width: 1, color: Color(logoColor)),
                    ),
                  ),
                ),
                 SizedBox(
                  height: deviceHieght*0.01,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: ValueListenableBuilder(
                      valueListenable: searchText,
                      builder: (context, searchValue, _) {
                        if (searchValue.isEmpty || searchValue == '') {
                          return UsersList();
                        }
                        return SearchUserList(
                          searchText: searchValue,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
