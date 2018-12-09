# chat/consumers.py
from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
import json
import numpy as np
import threading
from threading import Timer,Thread,Event
from multiprocessing import Pool
import random
import time
import generate
import user_struct
import area_struct
import check_area
import cluster

class MyThread(Thread):
    def __init__(self, event, chat):
        Thread.__init__(self)
        self.stopped = event
        self.chat_class = chat
        self.users_in_thread = None
        self.count = 0

    def run(self):
        while not self.stopped.wait(1.6):
            # call a function
            self.let_do()


    def let_do(self):
        # 1.. gПросто точки и положение

        areas = []
        for diction in self.chat_class._message:
            area = area_struct.area_struct(diction['path'],diction['identifier'])
            areas.append(area)
        
        if (self.users_in_thread == None):
            points, self.users_in_thread = generate.generate_points(100, 1000)
        else :
            self.users_in_thread = check_area.check_square_area(areas, self.users_in_thread)
            data = cluster.prepare_points(self.users_in_thread)
            res = cluster.get_clusters(data, 10)
            print(res)
            points, self.users_in_thread = generate.generate_timestap(self.users_in_thread, 100, 1000,res)
        # 2.. Отображение оластей
        
        
        async_to_sync(self.chat_class.channel_layer.group_send)(
                self.chat_class.room_group_name,
                {
                    'type': 'chat_message',
                    'message': points
                    # {
                    #     'x' : str(np.random.geometric(p=0.35, size=1)[0]%100),
                    #     'y' : str(np.random.geometric(p=0.35, size=1)[0]%100),
                    #     'timestamp' : "35434.5",
                    #     'identifier' : str(index%25)
                    # }
                }
        )  
        #for index,data in enumerate(np.random.randint(3, size=10000)):  
        
          
                    


class ChatConsumer(WebsocketConsumer):
    
    

    def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = 'chat_%s' % self.room_name

        # Join room group
        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name,
            self.channel_name
        )
        
        
        stopFlag = Event()
        thread = MyThread(stopFlag, self)
        thread.start()
        
        self.accept()


    def disconnect(self, close_code):
        # Leave room group
        async_to_sync(self.channel_layer.group_discard)(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        
        self._message = message
        
        print("Recieve new set")
        print(self._message)

        # Send message to room group
        async_to_sync(self.channel_layer.group_send)(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message
            }
        )

    # Receive message from room group
    def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        self.send(text_data=json.dumps({
            'message': message
        }))
