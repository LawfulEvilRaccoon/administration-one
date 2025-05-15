User.create(username: "admin", 
            email_address: "admin@example.com",
            password: "Password1234",
            password_confirmation: "Password1234",
            is_admin: true)

User.create(username: "guest", 
            email_address: "guest@example.com",
            password: "Password1234",
            password_confirmation: "Password1234")

User.all.each { |user| AttachAvatarToUserJob.perform_now(user: user) }