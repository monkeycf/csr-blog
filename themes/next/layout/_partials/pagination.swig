{% if page.prev or page.next %}
  <nav class="pagination">
    {{
      paginator({
        prev_text: 'previous',
        next_text: 'next',
        mid_size: 1
      })
    }}
  </nav>
{% endif %}
