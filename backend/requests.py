
import mysql.connector
from mysql.connector import Error
from flask import Flask, request
import json
import string
import random
import gensim
import numpy as np
from cryptography.fernet import Fernet
import os
app = Flask(__name__)

model = gensim.models.KeyedVectors.load_word2vec_format('./GoogleNews-vectors-negative300.bin', binary=True)  

connection = mysql.connector.connect(host='localhost',
                                    database='licenta',
                                    user='root',
                                    password = '')

        
cursor = connection.cursor(buffered = True)

# @app.route("/")
# def f():
#     loginData = []
#     return "Hello world"

#verific daca adresa de email e in BD
def connected(email,  password):
    q = f"select email, password from Users where email = \"{email.replace(' ', '')}\" and password = \"{password.replace(' ', '')}\""
    cursor.execute(q)
    # cursor.execute('select * from Users;')
    
    myresult = cursor.fetchall()

    for x in myresult:
        return 1
    return 0


    if(len(myresult)==1):
        return 1
    else: return 0

#generez token
def tokenGenerator(size = 8, chars=string.ascii_uppercase + string.digits):
   return ''.join(random.choice(chars) for _ in range(size))

@app.route("/login", methods = [ 'GET', 'POST'])
def login():

    r = json.loads(request.data.decode('utf-8'))
    #r e dictionar u email si password
    print(r['email'])
    print(r['password'])
    x = connected(r['email'],r['password'])

    #check if user is in DB
    selectUserId = f"select id from Users where  email = \"{r['email']}\" and password = \"{r['password']}\""
    print(selectUserId)
    cursor.execute(selectUserId)
    userID = cursor.fetchall()
    print("SELECTED USER")
    if len(userID) == 0:
        return json.dumps({
            'success': 'no'
        }) 
    print(userID[0][0])

    if(userID[0][0] == 0):
        response = { 'success' : "no"}
    else:
        token = tokenGenerator()
        #add user with token
        addUserToken = f"insert into usersToken (userid, token) values  ({userID[0][0]}, \"{token}\" )"
        cursor.execute(addUserToken)
        connection.commit()

        response = {
            'success': "yes",
            'token': token
        }
    print(response)
    return json.dumps(response)

@app.route("/register", methods = ['GET', 'POST'])
def register():

    r = json.loads(request.data.decode('utf-8'))

    insertUser = f"insert into Users (firstName, lastName, email,password,usertags) values (\"{r['first_name']}\" , \"{r['last_name']}\" , \"{r['email']}\", \"{r['password']}\",\"{r['userstags']}\")"
    
    cursor.execute(insertUser)
    connection.commit()

    selectid = f"select Id from Users where email = \"{r['email']}\" and password = \"{r['password']}\""
    cursor.execute(selectid)
    userID = cursor.fetchall()

    token = tokenGenerator()
    addUserToken = f"insert into usersToken (userid, token) values  ({userID[0][0]}, \"{token}\" )"
    cursor.execute(addUserToken)
    connection.commit()

    response = {
            'success': "yes",
            'token': token
        }
    return json.dumps(response)


def getUserID(token):
    print(token)
    id = f"select userid from usersToken where token = \"{token}\""  

    print(id)
    cursor.execute(id)
    result = cursor.fetchall()

    return result[0][0]

@app.route("/addtag", methods = ['GET', 'POST'])
def addtag():
    r = json.loads(request.data.decode('utf-8'))

    token = r['token']
    print(r['token'])
    userid = getUserID(token)

    print(userid)
    print("ADD TAG")    

    try:
        insertLocation = f"insert into tag(userid,name,color) values ({userid},\"{r['name']}\",\"{r['color']}\")"
        print(insertLocation)
    except e:
        print(e)

    cursor.execute(insertLocation)

    connection.commit()

    return "added" 


@app.route("/returnalltags", methods = ['GET', 'POST'])
def returnalltags():
    r = json.loads(request.data.decode('utf-8'))

    # token = r['token']
    # print(r['token'])
    # userid = getUserID(token)

    #selectez tagurile 
    # if 'id' not in r:
    print(r['token'])
    userid = getUserID(r['token'])
    print("r id din return all tags")
    print(userid)

    selectUserTags = f"select id, name, color from tag where userid = {userid}" 
    cursor.execute(selectUserTags)
    tags = cursor.fetchall()
    print(tags)
    #voi retine datele astea intr-un dictionar [{'nume': tagname, 'color': colorname}]
    l = []

    for i in range(len(tags)):
        tag = {
            'id': tags[i][0],
            'name': tags[i][1],
            'color': tags[i][2],
        }
        l.append(tag)
    print("---------------")
    print(l)
    response = {
            'success': "yes",
            'list': l
        }
    print(response)
    return json.dumps(response)

@app.route("/returnalltags_friend", methods = ['GET', 'POST'])
def returnalltags_friend():
    r = json.loads(request.data.decode('utf-8'))

    # token = r['token']
    # print(r['token'])
    # userid = getUserID(token)

    #selectez tagurile 
    # if 'id' not in r:
    # print(r['token'])
    # userid = getUserID(r['token'])
    # print("r id din return all tags")
    # print(userid)
    userid = int(r['id'])

    selectUserTags = f"select id, name, color from tag where userid = {userid}" 
    cursor.execute(selectUserTags)
    tags = cursor.fetchall()
    print(tags)
    #voi retine datele astea intr-un dictionar [{'nume': tagname, 'color': colorname}]
    l = []

    for i in range(len(tags)):
        tag = {
            'id': tags[i][0],
            'name': tags[i][1],
            'color': tags[i][2],
        }
        l.append(tag)
    print("---------------")
    print(l)
    response = {
            'success': "yes",
            'list': l
        }
    print(response)
    return json.dumps(response)



@app.route("/returntagsforlocation", methods = ['GET', 'POST'])
def returntagslocation():
    r = json.loads(request.data.decode('utf-8'))
    print(r['placeid'])

    userid = getUserID(r['token'])
    #selectez tagurile de la locatia dorita
    selectUserTags = f"select tagID from taggedPlaces where userID = {userid} and place_id = \"{r['placeid']}\"" 

    cursor.execute(selectUserTags)
    tags = cursor.fetchall()
    print(tags)
    #tags e lista id urilor tagurilor locatiei
    #voi retine datele astea intr-un dictionar [{'nume': tagname, 'color': colorname}]
    l = []
    print(len(tags))
    for i in range(len(tags)):
        print(i)
        selectTag = f"select  name, color from tag where id = {tags[i][0]}"

        cursor.execute(selectTag)
        lis = cursor.fetchall()

        tag = {
            'id': i,
            'name': lis[0][0],
            'color': lis[0][1],
        }
        l.append(tag)

    selectReview = f"select review from review where  userid = {userid} and placeid = \"{r['placeid']}\""

    cursor.execute(selectReview)
    rev = cursor.fetchall()
    
    if(len(rev)==0):
        r = "This location doesn't have a review"
    else: 
        r = rev[0][0]        
    print("location container data")
    print(l)
    response = {
            'review' : r,
            'success': "yes",
            'list': l
        }

    return json.dumps(response)

@app.route("/returntagsforlocation_friend", methods = ['GET', 'POST'])
def returntagslocation_friend():
    r = json.loads(request.data.decode('utf-8'))
    print(r['placeid'])

    # userid = getUserID(r['token'])
    userid = r['id']
    #selectez tagurile de la locatia dorita
    selectUserTags = f"select tagID from taggedPlaces where userID = {userid} and place_id = \"{r['placeid']}\"" 

    cursor.execute(selectUserTags)
    tags = cursor.fetchall()
    print(tags)
    #tags e lista id urilor tagurilor locatiei
    #voi retine datele astea intr-un dictionar [{'nume': tagname, 'color': colorname}]
    l = []
    print(len(tags))
    for i in range(len(tags)):
        print(i)
        selectTag = f"select  name, color from tag where id = {tags[i][0]}"

        cursor.execute(selectTag)
        lis = cursor.fetchall()

        tag = {
            'id': i,
            'name': lis[0][0],
            'color': lis[0][1],
        }
        l.append(tag)

    selectReview = f"select review from review where  userid = {userid} and placeid = \"{r['placeid']}\""

    cursor.execute(selectReview)
    rev = cursor.fetchall()
    
    if(len(rev)==0):
        r = "This location doesn't have a review"
    else: 
        r = rev[0][0]        
    print("location container data")
    print(l)
    response = {
            'review' : r,
            'success': "yes",
            'list': l
        }

    return json.dumps(response)


@app.route("/home", methods = ['GET', 'POST'])
def getUsersLocations():
    r = json.loads(request.data.decode('utf-8'))

    placesIDlist = []
   
    token = r['token']
    userid = getUserID(token)
    print(userid)
    print("iiiiiiiiiiiiiiiiiiiiiiddddddddddddddddddddddddddddddd")
    
    # userid = getUserID(r['token'])
    # print(userid)
    takePlaceID = f"select distinct place_id from taggedPlaces where userID = {userid}"
    print(takePlaceID)

    cursor.execute(takePlaceID)
    places = cursor.fetchall()
    print(len(places))

    if(len(places) != 0):
        for i in range(len(places)):
            placesIDlist.append(places[i][0])

    cursor.execute(f'select place_id, tagID from taggedPlaces where userID = {userid}')
    lines = cursor.fetchall()
    
    places_with_tags = dict()
    for line in lines:
        places_with_tags[line[0]] = places_with_tags.get(line[0], []) + [line[1]]

    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()
    else: 
        contents = ""

    response = {
        'id': userid,
        'success' : 'yes',
        'placesid' : placesIDlist,
        'places_with_tags': places_with_tags,
        'file_path': contents
    }
    
    return json.dumps(response)   

@app.route("/home_friend", methods = ['GET', 'POST'])
def getUsersLocationsFriend():
    r = json.loads(request.data.decode('utf-8'))

    placesIDlist = []
   
    # token = r['token']
    # userid = getUserID(token)
    # print(userid)
    # print("iiiiiiiiiiiiiiiiiiiiiiddddddddddddddddddddddddddddddd")
    userid = int(r['id'])
    
    # userid = getUserID(r['token'])
    # print(userid)
    takePlaceID = f"select distinct place_id from taggedPlaces where userID = {userid}"
    print(takePlaceID)

    cursor.execute(takePlaceID)
    places = cursor.fetchall()
    print(len(places))

    if(len(places) != 0):
        for i in range(len(places)):
            placesIDlist.append(places[i][0])

    cursor.execute(f'select place_id, tagID from taggedPlaces where userID = {userid}')
    lines = cursor.fetchall()
    
    places_with_tags = dict()
    for line in lines:
        places_with_tags[line[0]] = places_with_tags.get(line[0], []) + [line[1]]

    # title = str(userid) + ".txt"
    # filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    # if os.path.exists(filep):
    #     f = open(filep, "r")
    #     contents = f.read()
    #     f.close()
    # else: 
    #     contents = ""

    response = {
        'id': userid,
        'success' : 'yes',
        'placesid' : placesIDlist,
        'places_with_tags': places_with_tags,
        # 'file_path': contents
    }
    
    return json.dumps(response)   

#   DRAWER PART
#vreau sa iau numele si nr de locuri vizitate de persoana x
#functie care returneaza id pe baza tokenului

# def getUserID(token):
#     print(token)
#     id = f"select userid from usersToken where token = \"{token}\""  

#     print(id)
#     cursor.execute(id)
#     result = cursor.fetchall()

#     return result[0][0]

# # #fct care returneaza numele si nr de locuri din tagged places
@app.route("/drawer", methods = ['GET', 'POST'])
def getDrawerInfo():
    r = json.loads(request.data.decode('utf-8'))

    placesIDlist = []

    token = r['token']
    userid = getUserID(token)

    print("USR ID drawer")
    print(userid)
    firstName = f"select firstName from Users where id = {userid}" 

    cursor.execute(firstName)
    fn = cursor.fetchall()

    lastName = f"select lastName from Users where id = {userid}" 

    cursor.execute(lastName)
    ln = cursor.fetchall()

    username = fn[0][0] + " " + ln[0][0]
    print("USERNAME")
    print(username)
    #nr locatii vizitate :D

    placesNumber = f"select count(distinct place_id) from taggedPlaces where userID = {userid}" 
    
    cursor.execute(placesNumber)
    pn = cursor.fetchall()

    print("PLACES NUMBEER")
    print(pn[0][0])

    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()
    else: 
        contents = ""
    
    # print("contentssss")
    # print(contents)

    response = {
        'response' : 'yes',
        'username': username,
        'places_number': pn[0][0],
        'file_path': contents
    }

    return json.dumps(response)

@app.route("/accountsettingsinfo", methods = ['GET', 'POST'])
def accset():
    r = json.loads(request.data.decode('utf-8'))

    placesIDlist = []

    token = r['token']
    userid = getUserID(token)

    print("USR ID drawer")
    print(userid)
    #username = nume + prenume
    firstName = f"select firstName from Users where id = {userid}" 

    cursor.execute(firstName)
    fn = cursor.fetchall()
    print(firstName)
    lastName = f"select lastName from Users where id = {userid}" 
    print(lastName)
    cursor.execute(lastName)
    ln = cursor.fetchall()

    username = fn[0][0] + " " + ln[0][0]
    print("USERNAME")
    print(username)
    #nr locatii vizitate :D

    placesNumber = f"select count(distinct place_id) from taggedPlaces where userID = {userid}" 
    cursor.execute(placesNumber)
    pn = cursor.fetchall()

    #folllowing/er
    followers = f"select count(frienduserid) from followedAccounts where userid = {userid}"
    cursor.execute(followers)
    nr_followers = cursor.fetchall()

    following = f"select count(userid) from followedAccounts where frienduserid = {userid}"
    cursor.execute(following)
    nr_following = cursor.fetchall()
    print("PLACES NUMBEER")

    print(nr_following[0][0])
    print(nr_followers[0][0])

    print(pn[0][0])

    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()

    else: 
        contents = ""
    

    response = {
        'response' : 'yes',
        'username': username,
        'places_number': pn[0][0],
        'nr_following':nr_following[0][0],
        'nr_followers':nr_followers[0][0],
        'file_path': contents
    }

    return json.dumps(response)


#------------------------------
@app.route("/editpagephoto", methods = ['GET', 'POST'])
def editphot():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])
    
    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()
    else: 
        contents = ""
    
    response = {
        'response' : 'yes',
        'file_path': contents
    }

    return json.dumps(response)
#------------------------------
@app.route("/addplacestags", methods = ['GET', 'POST'])
def addLocationTags():
    r = json.loads(request.data.decode('utf-8'))

    print("add TAG")
    token = r['token']
    userid = getUserID(token)

    print(userid)
    print("ADD TAG")    

    print(r['id'])
    print(r['place_id'])
    print('\n\n\n')

    try:
        for i in range(len(r['id'])):
            insertLocation = f"insert into taggedPlaces(userid,tagid,place_id) values({userid},{r['id'][i]},\"{r['place_id']}\")"
            print(insertLocation)
            cursor.execute(insertLocation)

            connection.commit()

        if(r['text']):
                try:
                    insertComm = f"insert into review (userid,placeid,review) values({userid},\"{r['place_id']}\",\"{r['text']}\")"
                    print(insertComm)
                    cursor.execute(insertComm)
                    connection.commit()

                except r:
                    pass

    except e:
        pass

    return "DB" 


@app.route("/deleteTag", methods = ['GET', 'POST'])
def deleteTag():
    r = json.loads(request.data.decode('utf-8'))
    
    token = r['token']
    userid = getUserID(token) 

    deleteFromTag = f"delete from tag where id = \"{r['id']}\" and userid = {userid}" 
    deleteFromTaggedPlaces = f"delete from taggedPlaces where tagid = \"{r['id']}\" and userid = {userid}"

    cursor.execute(deleteFromTag)
    connection.commit()

    cursor.execute(deleteFromTaggedPlaces)
    connection.commit()

    return "deleted" 
#------------------------------------------edit part------------------------------------------
@app.route("/showUserdata", methods = ['GET', 'POST'])
def showData():
    r = json.loads(request.data.decode('utf-8'))
    
    token = r['token']
    userid = getUserID(token) 

    selectdata = f"select  firstName, lastName, password, email from Users where id = {userid}" 

    cursor.execute(selectdata)
    data = cursor.fetchall()
    # connection.commit()

    # selectphoto = f"select file from usersphoto where userid = {userid} order by id desc limit 1"
    # print(selectphoto)
    # cursor.execute(selectphoto)
    # result = cursor.fetchall()

    # if(len(result)==0):
    #     r = "" 
    # else: 
    #     r = result[0][0]

    # print("result photo")
    # print(r)

    fn = data[0][0]
    ln = data[0][1]
    password = data[0][2]
    print(fn)
    print(ln)
    print(password)

    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()
    else: 
        contents = ""
    
    

    r = {
        'result' : 'yes',
        'first_name': fn,
        'last_name': ln,
        'password':password,
        'filepath': contents
    }    

    return json.dumps(r)

@app.route("/update", methods = ['GET', 'POST'])
def updatefn():
    r = json.loads(request.data.decode('utf-8'))
    print("------------------------------------update")
    token = r['token']
    print(token)
    userid = getUserID(token) 
    print(userid)

    upd = ""

    if(r['first_name'] != ""):
        upd = f"firstName = \"{r['first_name']}\""
    
    if(r['last_name'] != ""):
        if upd != "":
            upd += ", "
        upd+= f"lastName = \"{r['last_name']}\""

    s = ""
    if upd == "":
        return "updated"
    s = s + f"update Users set {upd} where Id = {userid}"
    print(s)

    updatedata = f"{s}" 
    print(updatedata)

    cursor.execute(updatedata)
    connection.commit()

    return "updated"

#ar trebui sa verific si daca contul userului mai exista
# @app.route("/follow", methods = ['GET', 'POST'])
# def follow():
#     r = json.loads(request.data.decode('utf-8'))

#     token = r['token']
#     userid = getUserID(token) 
#     print(userid)
#     #folowing -> count(friends user id)
#     #followers -> count user id where frienduserid = userid

#     following = f"select count(frienduserid) from followedAccounts where userid = {userid}"

#     cursor.execute(following)
#     nr_following = cursor.fetchall()

#     followers = f"select count(userid) from followedAccounts where frienduserid = {userid}"
    
#     cursor.execute(followers)
#     nr_followers = cursor.fetchall()
#     print(nr_following[0][0])
#     print(nr_followers[0][0])
#     r = {
#         'response' : "yes",
#         'nr_following': nr_following[0][0],
#         'nr_followers': nr_followers[0][0],
#     }    

#     return json.dumps(r)

@app.route("/deleteuser", methods = ['GET', 'POST'])
def deleteuser():
    r = json.loads(request.data.decode('utf-8'))

    token = r['token']
    userid = getUserID(token) 
    
    #delete users token
    ut = f"delete from usersToken where userid = {userid}"

    cursor.execute(ut)
    connection.commit()


    #delete from users table
    users = following = f"delete from Users where Id = {userid}"

    cursor.execute(users)
    connection.commit()

    #delete from followedAccount
    fa = f"delete from followedAccounts where userid = {userid} or frienduserid = {userid}"

    cursor.execute(fa)
    connection.commit()

    #delete from Tag
    t = f"delete from tag where userid = {userid}"

    cursor.execute(t)
    connection.commit()

    #delete from TaggedPlaces

    tp = f"delete from taggedPlaces where userID = {userid}"
    
    cursor.execute(tp)
    connection.commit()

    return "deleted"

def useridTOusername(id):
    print('inside useridtousername')
    print(id)
    selectUser = f"select firstName, lastName from Users where id = {id}"

    cursor.execute(selectUser)
    info = cursor.fetchall()

    username = f"{info[0][0]} {info[0][1]}"
    print(username)
    return username

@app.route("/friends", methods = ['GET', 'POST'])
def friendList():
    r = json.loads(request.data.decode('utf-8'))
    
    token = r['token']
    userid = getUserID(token) 

    selectdata = f"select frienduserid from followedAccounts where userid = {userid}" 

    cursor.execute(selectdata)
    data = cursor.fetchall()

    friendsNames = []

    print(data)
    for i in range(len(data)):
        
        username = useridTOusername(data[i][0])

        friendsNames.append( {
            'username': username,
            'id': data[i][0]
        })
    print(friendsNames)

    print(friendsNames)
    r = {
        'result' : 'yes',
        'list': friendsNames,
    }    

    return json.dumps(r)


@app.route("/getuserid", methods = ['GET', 'POST'])
def userid():
    r = json.loads(request.data.decode('utf-8'))
   
    token = r['token']
    
    userid = getUserID(token)

    title = str(userid) + ".txt"
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title

    if os.path.exists(filep):
        f = open(filep, "r")
        contents = f.read()
        f.close()
    else: 
        contents = ""
    
    response = {
        'id' : userid,
        'file_path': contents
    }

    # print("RESPONSE")
    # print(response)
    return json.dumps(response)   

@app.route("/specificitems", methods = ['GET', 'POST'])
def specificTag():
    r = json.loads(request.data.decode('utf-8'))
    
    l = []

    for i in range(len(r['list'])): #vreau sa am o lista cu id urile selectate
        sele = f"select place_id from taggedPlaces where tagid = \"{r['list'][i]['id']}\""
        cursor.execute(selectdata)
        data = cursor.fetchall()
        
        for placeid in (len(data)):
            l.append(data[i][0])

    return l

def getNrPlaces(id):
    nrplaces = f"select  count(distinct place_id) from taggedPlaces where userID = {id}"
    cursor.execute(nrplaces)
    currentFr = cursor.fetchall()

    print(currentFr[0][0])
    return currentFr[0][0]

@app.route("/searchfriends", methods = ['GET', 'POST'])
def persons():
    r = json.loads(request.data.decode('utf-8'))
    print(r)
    print("friends hereee")
    userid = getUserID(r['token'])

    #selectez userii care au primit deja o cerere de prietenie
    users_with_request_sent = f"select requestreceiverid from followRequests where requestsenderid = {userid}"
    cursor.execute(users_with_request_sent)
    users_sent = cursor.fetchall()

    users_ids = [linie[0] for linie in users_sent]

    if " " in r['name']:
        first = r['name'].split(" ")[0]
        last = r['name'].split(" ")[1]
       
        selectPersons = f"select Id, firstName, lastName from Users where (firstName = \"{first}\" and lastName = \"{last}\") or (firstName = \"{last}\" and lastName = \"{first}\")"
        cursor.execute(selectPersons)
        data = cursor.fetchall()

    else:
        first = r['name']

        selectPersons = f"select Id, firstName, lastName from Users where firstName = \"{first}\" or \"lastName = {first}\""

        cursor.execute(selectPersons)
        data = cursor.fetchall()

    selectCurrentFriends = f"select frienduserid from followedAccounts where userid = {userid}"
    print(selectCurrentFriends)

    cursor.execute(selectCurrentFriends)
    currentFr = cursor.fetchall()

    friendid = [linie[0] for linie in currentFr]
    print("aicii")
    print(friendid)

    persons = []

    for i in range(len(data)):
        if(data[i][0] in friendid ):
            continue

        nr_places = getNrPlaces(data[i][0])

        persons.append( {
            'id': data[i][0],
            'firstname': data[i][1],
            'lastname': data[i][2],
            'nr_places': nr_places
        })
    print(persons)

    r = {
        'result' : 'yes',
        'list': persons,
        'requested_users': users_ids
    }    

    return json.dumps(r)

# @app.route("/requestedUsers", methods = ['GET', 'POST'])
# def requestedUsers():
#     r = json.loads(request.data.decode('utf-8'))

#     #vreau sa selectez id urile pe care utilizatorul le urmareste deja ca sa nu existe duplicate
#     userid = getUserID(r['token'])
#     print(userid)

#     users_with_request_sent = f"select requestreceiverid from followRequests where requestsenderid = {userid}"
#     cursor.execute(users_with_request_sent)
#     users_sent = cursor.fetchall()

#     users_ids = [linie[0] for linie in users_sent]

#     r = {
#         'result' : 'yes',
#         'list': users_ids,
#     }    
#     return json.dumps(r)


@app.route("/sendfriendrequest", methods = ['GET', 'POST'])
def friendrequest():
    r = json.loads(request.data.decode('utf-8'))

    #vreau sa selectez id urile pe care utilizatorul le urmareste deja ca sa nu existe duplicate
    userid = getUserID(r['token'])
    print(userid)

    users_with_request_sent = f"select requestreceiverid from followRequests where requestsenderid = {userid}"
    cursor.execute(users_with_request_sent)
    users_sent = cursor.fetchall()

    users_ids = [linie[0] for linie in users_sent]


    if int(r['id']) not in users_ids:
        sendRequest = f"insert into followRequests (requestsenderid, requestreceiverid) values ({userid}, {int(r['id'])})"

        print(sendRequest)
        cursor.execute(sendRequest)
        connection.commit()

    # print(users_ids)
    # r = {
    #     'result' : 'yes',
    #     # 'list': users_ids,
    # }    
    # return json.dumps(r)
    return "sent"

@app.route("/followerslist", methods = ['GET', 'POST'])
def selectfollowers():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])
    print(userid)
    #trebuie sa selectez pers care au la friend id id-ul utilizatorului meu

    #am id urile utilizatorilor care l urmaresc pe utilizatorul meu
    selectfollowers = f"select userid from followedAccounts where frienduserid = {userid}"
    print(selectfollowers)

    cursor.execute(selectfollowers)
    currentFr = cursor.fetchall()

    print("id followers")
    print(currentFr)
    print(len(currentFr))

    persons = []

    #pt fiecare id iau id nume prenume
    for i in range(len(currentFr)):
        print(currentFr[i][0])
        selectfollwersinfo = f"select Id, firstName, lastName from Users where Id = {currentFr[i][0]}"

        cursor.execute(selectfollwersinfo)
        followers = cursor.fetchall()

        nr_places = getNrPlaces(followers[0][0])

        persons.append( {
            'id': followers[0][0],
            'firstname': followers[0][1],
            'lastname': followers[0][2],
            'nr_places': nr_places
        })
    print("from followers")
    print(persons)
    print(persons)

    r = {
        'result' : 'yes',
        'list': persons,
    }    

    return json.dumps(r)

@app.route("/followinglist", methods = ['GET', 'POST'])
def selectfollowing():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])

    #trebuie sa selectez pers pe care le urmareste utilizatorul aka userid = {userid}

    #am id urile utilizatorilor care l urmaresc pe utilizatorul meu
    selectfollowing = f"select frienduserid from followedAccounts where  userid = {userid}"

    cursor.execute(selectfollowing)
    currentFr = cursor.fetchall()

    persons = []

    #pt fiecare id iau id nume prenume
    for i in range(len(currentFr)):
        print({currentFr[i][0]})
        selectfollwinginfo = f"select Id, firstName, lastName from Users where Id = {currentFr[i][0]}"

        cursor.execute(selectfollwinginfo)
        followers = cursor.fetchall()

        nr_places = getNrPlaces(followers[0][0])

        persons.append( {
            'id': followers[0][0],
            'firstname': followers[0][1],
            'lastname': followers[0][2],
            'nr_places': nr_places
        })

    print("following list")
    print(persons)
    r = {
        'result' : 'yes',
        'list': persons,
    }    

    return json.dumps(r)

@app.route("/deletefollower", methods = ['GET', 'POST'])
def deletefolloweduser():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])

    f = f"delete from followedAccounts where userid= {r['id']} and frienduserid  = {userid}"
    cursor.execute(f)
    connection.commit()

    return "deleted"

@app.route("/deletefollowing", methods = ['GET', 'POST'])
def deletefollowinguser():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])

    f = f"delete from followedAccounts where frienduserid = {r['id']} and userid = {userid}"
    cursor.execute(f)
    connection.commit()

    return "deleted"

@app.route("/returnfollowrequests", methods = ['GET', 'POST'])
def followrequests():
    r = json.loads(request.data.decode('utf-8'))
    print("frequests")

    userid = getUserID(r['token'])
    print(userid)
    selectfuturefollowers = f"select requestsenderid from followRequests where  requestreceiverid = {userid}"
    print(selectfuturefollowers)
    cursor.execute(selectfuturefollowers)
    currentFr = cursor.fetchall()
    print(currentFr)
    persons = []

    #pt fiecare id iau id nume prenume
    for i in range(len(currentFr)):
        print({currentFr[i][0]})
        selectpersoninfo = f"select Id, firstName, lastName from Users where Id = {currentFr[i][0]}"

        cursor.execute(selectpersoninfo)
        personinfo = cursor.fetchall()

        nr_places = getNrPlaces(personinfo[0][0])

        persons.append( {
            'id': personinfo[0][0],
            'firstname': personinfo[0][1],
            'lastname': personinfo[0][2],
            'nr_places': nr_places
        })

    print(persons)
    r = {
        'result' : 'yes',
        'list': persons,
    }    

    return json.dumps(r)

@app.route("/deletefollowrequest", methods = ['GET', 'POST'])
def deleterequest():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])

    f = f"delete from followRequests where requestreceiverid ={userid} and requestsenderid = {r['id']}"
    cursor.execute(f)
    connection.commit()

    return "deleted"

@app.route("/acceptfollowrequest", methods = ['GET', 'POST'])
def acceptrequest():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])
    #userum meu cu tokenul este cel car o sa fie urmarit
    insertdata = f"insert into followedAccounts (userid, frienduserid) values ({r['id']},{userid}) "
    cursor.execute(insertdata)
    connection.commit()

    f = f"delete from followRequests where requestsenderid = {r['id']} and requestreceiverid = {userid}"
    cursor.execute(f)
    connection.commit()

    return "added"

@app.route("/correctcurrentpassword", methods = ['GET', 'POST'])
def currpass():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token']) #aflu care e userul meu
    print("de pe ft")
    print(userid)
    selectuserpassword = f"select password from Users where Id = {userid}"
    cursor.execute(selectuserpassword)
    current_password = cursor.fetchall()
    
    print("current_password")
    print(current_password[0][0])

    print(persons)
    r = {
        'result' : 'yes',
        'password': current_password[0][0],
    }    

    return json.dumps(r)  

@app.route("/updatepassword", methods = ['GET', 'POST'])
def updatepass():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token']) #aflu care e userul meu
    print("de pe ft")
    print(r['password'])

    updatepassword = f"update Users set password = \"{r['password']}\" where Id = {userid}" 
    cursor.execute(updatepassword)
    connection.commit()

    return "changed"

@app.route("/adduserphoto", methods = ['GET', 'POST'])
def insertphoto():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token']) #aflu care e userul meu
    print("de pe ft")
    print(userid)
    # insertdata = f"insert into followedAccounts (userid, frienduserid) values ({r['id']},{userid}) "
    print(len(r['filepath']))

    createuserfile(userid,r['filepath'])

    return "photo"

def createuserfile(userid, filepath):
    #creez un fisier cu numele userului

    title = f"{userid}.txt"
    print(title)
    filep = "/home/antonio/licenta/tagge_map/UsersPhotos/" + title
    f = open(filep, "w")


    f.write(filepath)
    f.close()

@app.route("/addusertags", methods = ['GET', 'POST'])
def addusertags():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token']) #aflu care e userul meu
    print("de pe ft pt adaugarea userstags")
    print(r['usertags'])
    print(userid)
    insertdata = f"update Users set usertags = \"{r['usertags']}\" where Id = {userid}"
    cursor.execute(insertdata)
    connection.commit()

    print("users tags added")

    return "tagsadded"

#--------------------------------------------------------------------------

@app.route('/reviewdefault', methods = ['GET', 'POST'])
def userlocationencode():
    r = json.loads(request.data.decode('utf-8'))

    qplace_ids = f"select distinct place_id from taggedPlaces"

    cursor.execute(qplace_ids)
    result = cursor.fetchall()

    place_ids = [linie[0] for linie in result]

    place_dict = {} #e un disctionar cu place_id si pt fiecare lista de tag-uri

    place_id_list = []

    for place_id in place_ids:
        #iau id-urile tag-urilor cu place-id ul dat
        qtags_place = f"select tagID from taggedPlaces where place_id=\"{place_id}\"" 
        cursor.execute(qtags_place)
        tags_place = cursor.fetchall()
        
        tag_list = []
        
        for tag in range(len(tags_place)):
            #pt fiecare tag din lista anterioara vreau sa iau numele
            
            tag_data = f"select name from tag where id = {tags_place[tag][0]}" 
            cursor.execute(tag_data)
            tag_name = cursor.fetchall()
            
            tag_list.append(tag_name[0][0])
            
        place_dict[place_id] = tag_list
        
    # print(place_dict)

    all_tags_encode = {}

    for place_id in place_ids:
        l = []
        for tag in place_dict[place_id]:
            try:
                l.append(model.word_vec(tag))
            except:
                pass
        l = np.array(l)
        l = np.mean(l,axis = 0) #doua axe, cuvinte si encodinguri si eu vrea media pe cuvinte
        print(l.shape)
        all_tags_encode[place_id] = l
        place_id_list.append(l)

    l = np.array(place_id_list)
                    
    #iau toate tag-urile utilizatorului
    #si le encodez
    #by default o sa apara locatiile recomandate pe baza tuturor tag-urilor utilizatorului

            
    id = f"select userid from usersToken where token = \"{r['token']}\""  

    cursor.execute(id)
    result = cursor.fetchall()

    allowed = r.get('list_ids', [])

    user_place_ids = f"select place_id, tagID from taggedPlaces where userID = {result[0][0]}"

    cursor.execute(user_place_ids)
    result = cursor.fetchall()

    if len(allowed) == 0:
        place_ids_list = list(set([linie[0] for linie in result]))# set - elimin duplicatele, apoi il transf in lista
    else:
        place_ids_list = list(set([linie[0] for linie in result if linie[1] in allowed]))

    #media encoding -urilor locatiilor userului

    user_location_encode = []

    for loc in place_ids_list:
        user_location_encode.append(all_tags_encode[loc])
        
    #media locatiillor pt ca vreau un vect pt toate locatiile
    user_location_encode = np.mean(user_location_encode, axis = 0)


    result = np.square(l - user_location_encode)
    r = np.sum(result, axis = 1)

    resultsorted = np.argsort(r)

    recomended_place_ids = []
    half = []

    for elem in resultsorted:
        recomended_place_ids.append(place_ids[elem])


    recomended_place_ids = list(dict.fromkeys(recomended_place_ids))
    print(recomended_place_ids) 

    c = int(len(recomended_place_ids)/2)
    print(c)

    for i in range(7):
        half.append(recomended_place_ids[i])

    print(half)
    response = {
        'list': half,#recomended_place_ids
    }

    return json.dumps(response)

#----------------------------------------------------------------------------
#recommendation after tag


@app.route('/reviewtag', methods = ['GET', 'POST'])
def recommendationtag():
    r = json.loads(request.data.decode('utf-8'))

    #imi fac o lista cu toate place_id urile distincte
    selectPlaceIds = f"select distinct place_id from taggedPlaces"
    cursor.execute(selectPlaceIds)
    result = cursor.fetchall()

    #lista cu place_id uri
    place_ids = [linie[0] for linie in result]
    print("place ids")
    print(place_ids)
    # print("place_id:")
    # print(place_ids)
    #aici o sa retin numele tag urilor care exista in baza de date
    tags_name = []
    tags_id = []

    #eu primesc o lista de tag-uri si vreau sa iau id.urile tagurilor care exista
    for i in range(len(r['tags'])):
        selectTags = f"select name,id from tag where name = \"{r['tags'][i]}\""
        cursor.execute(selectTags)
        a = cursor.fetchall()
        tags_name.append(a[0][0])
        tags_id.append(a[0][1])
    print("tags")
    print(tags_name)
    #pt fiecare place id verific daca are vreun tag din cele introduse de user
    #daca are il selectezl

    place_id_with_searched_tags = {}
    place_ids_list = []

    #selectez toate tag-urile pe care le are o locatie
    for i in range(len(place_ids)):
        #asta o sa selecteze toate tagurile pentru o locatie
        f = f"select tagID from taggedPlaces where place_id = \"{place_ids[i]}\""
        cursor.execute(f)
        r = cursor.fetchall()
        
        #in lista asta o sa adaug tag-urile locatiei dintre cele date de utilizator, daca locatia respectiva are vreun tag din cele introduse de utilizator
        place_id_searched_tags = []
        print(tags_id)
        for j in range(len(r)):
            if r[j][0] in tags_id:
                print("here 1")
                place_id_searched_tags.append(r[j][0])
                print("place id searched tags")
                print(place_id_searched_tags)
                print("here 3")
        if(len(place_id_searched_tags)!= 0):#eu mai sus pun in lista tagurile locatiei care au fost si cautate de user; daca lista e goala inseamna ca nu exista taguri comune deci nu l vreau in lista
            place_id_with_searched_tags[place_ids[i]] = place_id_searched_tags
            place_ids_list.append(place_ids[i])

    print("with searched tags")
    print(place_id_with_searched_tags)
    print(place_ids_list)


    place_ids_list = list(dict.fromkeys(place_ids_list))
    print(place_ids_list) 

    response = {
        'list': place_id_with_searched_tags,
        'place_ids': place_ids_list
    }

    return json.dumps(response)
#-----------------------------------------------------------------------------------------------

@app.route('/recommendedpeople', methods = ['GET', 'POST'])
def recommendedpeople():
    r = json.loads(request.data.decode('utf-8'))

    userid = getUserID(r['token'])
    print("userid form recommendation")
    print(userid)

    selectuserstags = f"select usertags from Users where Id = {userid}"
    cursor.execute(selectuserstags)
    usertags = cursor.fetchall()
    # print(usertags[0][0])

    usertags_aftersplit = usertags[0][0].split(",")
    # print(usertags_aftersplit)

    user_encoded_tags = []

    #dupa ce am obtinut tagurile utilizatorului vreau sa le encodez
    for tag in range(len(usertags_aftersplit)):
        try:
            # print("din fo0000000000000000000000000000000000000000or1")
            user_encoded_tags.append(model.word_vec(usertags_aftersplit[tag]))
            # print(user_encoded_tags)
            # print("din fo0000000000000000000000000000000000000000or2")
        except:
            pass
    
    print("tagstatgsasdgasdlg tags")

    #aici am teci codarea userului curent

    user_encoded = np.array(user_encoded_tags)#il fac array ca sa pot face media
    user_encoded = np.mean(user_encoded, axis = 0)#media codarii cuvintelor
    print("encoded user tags")
    print(user_encoded)

    #eu vreau sa selectez utilizatorii diveriti de cel curent si care nu e deja prieten cu cel curent => 
                                                                                                        #iau lista tuturor utilizatorilor 
                                                                                                        #iau lista utilizatorilor pe care i urmareste utilizatorul curent
                                                                                                        #din lista tuturo utilizatorilor scot utilizatorii urmariti
                                                                                                        # pentru lista rezultata encodez tagurile utilizatorilor
                                                                                                        #le sortez
                                                                                                        #returnez lista cu primii 6 utilizatori

    #iau lista cu toti utilizatorii

    select_all_users = f"select Id from Users where Id <> {userid}"                                                                                                    
    cursor.execute(select_all_users)
    all_users_result = cursor.fetchall()
    all_users = [linie[0] for linie in all_users_result]
    print("all users")
    print(all_users)

    #select following persons
    select_following = f"select frienduserid from followedAccounts where userid = {userid}"
    cursor.execute(select_following)
    following_users_result = cursor.fetchall()
    following_users = [linie[0] for linie in following_users_result]
    print("following users")
    print(following_users)

    #elimin din lista cu toti utilizatorii persoanele urmarite
    for user in range(len(following_users)):
        all_users.remove(following_users[user])

    print("list after removin following")
    print(all_users)

    #pentru fiecare utilizator vreau sa iau userstags si sa le encodez si apoi sa le pun intr-o lista :D

    all_users_tags_encode = {}
    users_enc = []
    index = []

    for user in range(len(all_users)): #in all users am id-urile utilizatorilor

        selectuserstags = f"select usertags from Users where Id = {all_users[user]}"
        cursor.execute(selectuserstags)
        usertags = cursor.fetchall()
        # print(usertags[0][0])
        if(not usertags):
            continue
        
        usertags_aftersplit = usertags[0][0].split(",")
        # print(usertags_aftersplit)

        user_encoded_tags = []

        #dupa ce am obtinut tagurile utilizatorului vreau sa le encodez
        for tag in range(len(usertags_aftersplit)):
            try:
                user_encoded_tags.append(model.word_vec(usertags_aftersplit[tag]))
                # print(user_encoded_tags)
            except:
                pass

        if len(user_encoded_tags) == 0:
            continue

        #aici am teci codarea userului curent
        user_encoded_tags = np.array(user_encoded_tags)#il fac array ca sa pot face media
        print(user_encoded_tags.shape)

        user_encoded_tags = np.mean(user_encoded_tags, axis = 0)#media codarii cuvintelor
        print(user_encoded_tags.shape)

        all_users_tags_encode[all_users[user]] = user_encoded_tags
        users_enc.append(user_encoded_tags)
        index.append(all_users[user])

    # print(all_users_tags_encode)

    # print("after mean")
    # print(all_users_tags_encode)
    
    users_enc = np.array(users_enc)
    result = np.square(users_enc - user_encoded)
    r = np.sum(result, axis = 1)
    print("r")
    print(r)
    resultsorted = np.argsort(r)
    print("resulted sort")
    print(resultsorted)
    recomended_people = []
    print("recommended peopole")

    for elem in resultsorted:
        recomended_people.append(index[elem])
    print(recomended_people)

    usernames = []
    places = []

    for elem in range(len(recomended_people)):
        print(elem)
        selectdata = f"select firstName, lastName from Users where Id = {recomended_people[elem]}"
        cursor.execute(selectdata)
        data = cursor.fetchall()

        username = [linie[0] + " " + linie[1] for linie in data]
        usernames.append(username[0])

        select_places = f"select count(distinct place_id) from taggedPlaces where userID = {recomended_people[elem]}"
        cursor.execute(select_places)
        r = cursor.fetchall()

        places.append(r[0][0])

    print(" peopole")

    print(usernames)
    print(places)

    response = {
        'response': "yes",
        'usernames': usernames,
        'places': places
    }

    return json.dumps(response)
        

app.run(host='0.0.0.0')
