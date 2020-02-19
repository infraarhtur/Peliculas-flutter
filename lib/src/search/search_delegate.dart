

import 'package:flutter/material.dart';
import 'package:peliculas2/src/models/pelicula_model.dart';
import 'package:peliculas2/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();
  String seleccion = '';
  // final peliculas = [
  //   'spiderman',
  //   'capitan america',
  //   'batman',
  //   'superman',
  //   'iron man',
  //   'iron man 2',
  //   'shazam'
  // ];
  final peliculasRecientes = ['spiderman', 'capitan america'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones del appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            print(seleccion);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
        child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.blueAccent,
      child: Text(seleccion),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son sugerencias que aparecen cuando las personas escriben

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPeliculas(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                    placeholder:  AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.contain,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context, null);
                      pelicula.uniqueId ='';
                      Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                    },
                    
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // final listaSugerida = (query.isEmpty)
    //     ? peliculasRecientes
    //     : peliculas
    //         .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
    //         .toList();

    // return ListView.builder(
    //     itemCount: listaSugerida.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(listaSugerida[i]),
    //         onTap: () {
    //           seleccion = listaSugerida[i];
    //           showResults(context);
    //         },
    //       );
    //     });
  }
}
