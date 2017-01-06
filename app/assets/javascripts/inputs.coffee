# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    $('#sortable-inputs').sortable
      items: 'tr'
      update: (event, ui) ->
        order = $('#sortable-inputs').sortable('serialize')
        event_id = $('#AddInputs').data("event-id")

        $.ajax
          type: 'POST'
          dataType: 'json'
          url: '/input_processings/reorder'
          data: { order: order, live_event_id: event_id }
          success: (data, textStatus, jqXHR) ->
                #alert "Success"
          error: (jqXHR, textStatus, errorThrown) ->
                alert errorThrown
        
    $('#AddInputs').click (e)->
        checkedValues = $('.live_event_input:checked').map(->
            @id
        ).get()
        
        event_id = $('#AddInputs').data("event-id")

        e.preventDefault()
        
        $.ajax '/input_processings/add_wids',
            type: 'GET'
            dataType: 'json'
            data: { checkedInputs: checkedValues, event_id: event_id }
            
            success: (data, textStatus, jqXHR) ->
                $("#modal-window-add-inputs").html(data.modal_content)
                $("#modal-window-add-inputs").modal("show")
            error: (jqXHR, textStatus, errorThrown) ->
                alert errorThrown
    return

$ ->    
    $('#ReplacePlaylist').click (e)->
        checkedValues = $('.live_event_input:checked').map(->
            @id
        ).get()
        
        event_id = $('#ReplacePlaylist').data("event-id")
        
        e.preventDefault()
        
        $.ajax '/input_processings/replace_wids',
            type: 'GET'
            dataType: 'json'
            data: { checkedInputs: checkedValues, event_id: event_id }
            
            success: (data, textStatus, jqXHR) ->
                $("#modal-window-replace-inputs").html(data.modal_content)
                $("#modal-window-replace-inputs").modal("show")
            error: (jqXHR, textStatus, errorThrown) ->
                alert errorThrown
    return    
    