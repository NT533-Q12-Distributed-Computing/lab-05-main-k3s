def handle(event, context):
    user_input = event.body or "UIT"
    return f"Hello from OpenFaaS 👋, {user_input}!"
