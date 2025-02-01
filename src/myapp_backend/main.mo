import List "mo:base/List";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";

actor {

    let g = Source.Source();
    public type User = {
        id : Text;
        name : Text;
        age : Nat;
        owner : Text;
    };
    stable var users : List.List<User> = List.nil<User>();
    public shared (msg) func addUsers(name : Text, age : Nat) : async [User] {
        let owner = Principal.toText(msg.caller);
        let newUser : User = {
            id = UUID.toText(await g.new());
            name = name;
            age = age;
            owner = owner;
        };
        
        users := List.push(newUser, users);

        let filteredUsers = List.filter<User>(users, func user { user.owner == owner });
        return List.toArray(filteredUsers);
    };

    public shared (msg) func getUsers() : async [User] {
        let owner = Principal.toText(msg.caller);

        let filteredUsers = List.filter<User>(users, func user { user.owner == owner });
        return List.toArray(filteredUsers);
    }


};
