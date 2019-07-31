(function() {
  'use strict';
  var $searchableTree;

  $(function() {
    var search = function(e) {
      var pattern = $('#input-search').val();
      var options = {
        ignoreCase: $('#chk-ignore-case').is(':checked'),
        exactMatch: $('#chk-exact-match').is(':checked'),
        revealResults: $('#chk-reveal-results').is(':checked')
      };
      var results = window.$searchableTree.treeview('search', [ pattern, options ]);

      var output = '<p>' + results.length + ' matches found</p>';
      $.each(results, function (index, result) {
        output += '<p>- ' + result.text + '</p>';
      });
      $('#search-output').html(output);
    }

    $('#btn-search').on('click', search);
    $('#input-search').on('keyup', search);

    $('#btn-clear-search').on('click', function (e) {
      $searchableTree.treeview('clearSearch');
      $('#input-search').val('');
      $('#search-output').html('');
    });

    var create_folder = function(e) {
      var folder_id = $('.node-selected:first').data('folderid');
      folder_id = (folder_id == 0 || folder_id == undefined) ? null : folder_id;
      var token = $('meta[name="csrf-token"]').attr('content');

      $.ajax({
        type: 'POST',
        url: '/folder',
        data: {
          folder: {
            name: $('#input-create').val(),
            folder_id: folder_id
          }
        },
        dataType: 'JSON',
        beforeSend: function (xhr) {
          xhr.setRequestHeader('X-CSRF-Token', token)
        },
        'Content-Type': 'application/json',
        success: function(data, status, xhr) {
          $searchableTree = $('#tree').treeview({
            levels: 1,
            nodeIcon: "glyphicon glyphicon-folder-close",
            data: data
          })

          $('#input-create').val('')
          $('#input-search').val('')
          format_message('Folder created successfully.', 'success')
        },
        error: function(jqXHR, textStatus, errorThrown) {
          format_message(jqXHR.responseText, 'danger')
        }
      });
    }

    var create_note = function(e) {
      var folder_id = $('.node-selected:first').data('folderid');
      folder_id = (folder_id == 0 || folder_id == undefined) ? null : folder_id;
      var token = $('meta[name="csrf-token"]').attr('content');

      $.ajax({
        type: 'POST',
        url: '/note',
        data: {
          note: {
            name: $('#input-create').val(),
            folder_id: folder_id
          }
        },
        dataType: 'JSON',
        beforeSend: function (xhr) {
          xhr.setRequestHeader('X-CSRF-Token', token)
        },
        'Content-Type': 'application/json',
        success: function(data, status, xhr) {
          $searchableTree = $('#tree').treeview({
            levels: 1,
            nodeIcon: "glyphicon glyphicon-folder-close",
            data: data
          })

          $('#input-create').val('')
          $('#input-search').val('')
          format_message('Note created successfully.', 'success')
        },
        error: function(jqXHR, textStatus, errorThrown) {
          format_message(jqXHR.responseText, 'danger')
        }
      });
    }

    $('#create-folder').on('click', create_folder);
    $('#create-note').on('click', create_note);
  });

  var format_message = function(message, type) {
    var html = "<div class='alert alert-" + type + "' role='alert'>"
    html += "<button class='close' 'aria-label'='Close' data-dismiss='alert' type='button'>"
    html += "<span 'aria-hidden'='true'>×</span></button>"
    html += message + '</br>'
    html += "</div>";
    $('#flash').html(html)
  }
})();
