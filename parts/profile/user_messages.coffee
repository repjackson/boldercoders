if Meteor.isClient
    Router.route '/user/:username/messages', (->
        @layout 'profile_layout'
        @render 'user_messages'
        ), name:'user_messages'
    
    Template.user_messages.onCreated ->
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'thought'


    Template.user_messages.onCreated ->
        @autorun => Meteor.subscribe 'user_messages', Router.current().params.username
        @autorun => Meteor.subscribe 'model_docs', 'message'

    Template.user_messages.events
        'keyup .new_message': (e,t)->
            if e.which is 13
                val = $('.new_message').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'message'
                    body: val
                    target_user_id: target_user._id
                val = $('.new_message').val('')

        'click .submit_message': (e,t)->
            val = $('.new_message').val()
            console.log val
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.insert
                model:'message'
                body: val
                target_user_id: target_user._id
            val = $('.new_message').val('')



    Template.user_messages.helpers
        user_messages: ->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'message'
                target_user_id: target_user._id

        slots: ->
            Docs.find
                model:'slot'
                _author_id: Router.current().params.user_id


if Meteor.isServer
    Meteor.publish 'user_messages', (username)->
        Docs.find
            model:'message'
