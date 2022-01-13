class Band {
  String id;
  String name;
  int votes;

  Band({
    this.id,
    this.name,
    this.votes
  });

 //Creo el factory recibe un jason map
  factory Band.fromMap(Map <String, dynamic> obj)
    =>  Band(
      //Se valida para ver si no viene el dato y que no reviente el progrqama
      id: obj.containsKey('id') ? obj['id']: 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'noname',
      votes:obj.containsKey('votes') ?  obj['votes'] : 0
    );
}