import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/firestore/database.dart';
import 'package:flutter_1/main_pages/myHomePage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class FriendPage extends StatefulWidget {
  final String uid;
  const FriendPage({Key? key, required this.uid}) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  static const historyLength = 5;
  FloatingSearchBarController controller = FloatingSearchBarController();

  List<String> _searchHistory = [];

  List<String> filteredSearchHistory = [];

  String? selectedTerm;

  List<String> filterSearchTerms({
    required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchHistory(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchHistory(term);
    addSearchTerm(term);
  }

  @override
  void initState() {
    super.initState();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            seacrhTerm: selectedTerm,
            uid: widget.uid,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Find your friend!',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchHistory(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatefulWidget {
  final String? seacrhTerm;
  final String uid;
  const SearchResultsListView(
      {Key? key, required this.seacrhTerm, required this.uid})
      : super(key: key);

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  bool sendRequest = false;

  @override
  Widget build(BuildContext context) {
    if (widget.seacrhTerm == null) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 64,
          ),
          Text(
            'Start searching',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ));
    }

    final fsb = FloatingSearchBar.of(context);

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .where('name', isEqualTo: widget.seacrhTerm)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          return ListView(
            padding: EdgeInsets.only(top: 100),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              List friendList = data['friend'] as List;
              return ListTile(
                title: Text(data['name'].toString()),
                subtitle: Text(data['email'].toString()),
                trailing: friendList.contains(widget.uid)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'friend',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        child: Text('add friend'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              sendRequest ? Colors.grey : Colors.brown),
                        ),
                        onPressed: () async {
                          await DatabaseService(uid: data['uid'].toString())
                              .addFriend(widget.uid);
                          setState(() {
                            sendRequest = true;
                          });
                        },
                      ),
              );
            }).toList(),
          );
        });
  }
}
