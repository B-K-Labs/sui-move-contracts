module botp::botp {

    use 0x1::Signer;
    use 0x1::Table;
    use std::string;
    use sui::event::emit;

    /// Define a user struct containing relevant fields
    struct User has key {
        is_user: bool,
        role: u64,
        profile: vector<u8>,
        partner: address,
    }

    /// Define an OTP user containing the encrypted message
    struct OTPUser has key {
        enc_message_otp: vector<u8>,
    }

    /// Define agent who manages OTP users
    struct Agent has key {
        users: Table::Table<address, OTPUser>,
    }

    /// Define the primary botp structure for managing agents
    struct BOTP has key {
        agents: Table::Table<address, Agent>,
        users: Table::Table<address, User>,
    }

    /// Events
    public fun register_event(address_user: address, role: u64, profile: vector<u8>) {
        // Equivalent to Solidity's `emit Register`
        emit<Event>({address_user, role, profile});
    }

    public fun profile_event(address_user: address, profile: vector<u8>) {
        // Equivalent to Solidity's `emit Profile`
        emit<Event>({address_user, profile});
    }

    public fun broadcast_event(agent_addr: address, user_addr: address, id: vector<u8>, enc_message: vector<u8>) {
        // Equivalent to Solidity's `emit Broadcast`
        emit<Event>({agent_addr, user_addr, id, enc_message});
    }

    public fun history_event(agent_addr: address, user_addr: address, id: vector<u8>, enc_message: vector<u8>, signature: vector<u8>) {
        // Equivalent to Solidity's `emit History`
        emit<Event>({agent_addr, user_addr, id, enc_message, signature});
    }

    /// Initialize the contract, creating empty tables for agents and users
    public fun initialize_botp(account: &signer): BOTP {
        BOTP {
            agents: Table::new(),
            users: Table::new(),
        }
    }

    /// Register a new user
    public fun register_user(botp: &mut BOTP, signer: &signer, role: u64, profile: vector<u8>) {
        let sender = Signer::address_of(signer);
        let user = User {
            is_user: true,
            role: role,
            profile: profile,
            partner: sender,
        };
        Table::add(&mut botp.users, sender, user);
        register_event(sender, role, profile);
    }

    /// Update a user's profile
    public fun update_profile(botp: &mut BOTP, signer: &signer, profile: vector<u8>) {
        let sender = Signer::address_of(signer);
        let user = Table::borrow_mut(&mut botp.users, sender);
        user.profile = profile;
        profile_event(sender, profile);
    }

    /// Get a user's profile
    public fun get_user_profile(botp: &BOTP, user_addr: address): vector<u8> {
        let user = Table::borrow(&botp.users, user_addr);
        user.profile
    }

    /// Send encrypted messages to users by agent
    public fun send_enc_message(botp: &mut BOTP, signer: &signer, user_addrs: vector<address>, ids: vector<vector<u8>>, enc_messages: vector<vector<u8>>) {
        let sender = Signer::address_of(signer);
        let agent = Table::borrow_mut(&mut botp.agents, sender);
        let length = vector::length(&enc_messages);

        let mut i: u64 = 0;
        while (i < length) {
            let user_addr = vector::borrow(&user_addrs, i);
            let enc_message = vector::borrow(&enc_messages, i);
            let id = vector::borrow(&ids, i);

            let otp_user = OTPUser {
                enc_message_otp: *enc_message
            };

            Table::add(&mut agent.users, *user_addr, otp_user);
            broadcast_event(sender, *user_addr, *id, *enc_message);

            i = i + 1;
        }
    }

    /// Get encrypted message for a specific user from an agent
    public fun get_enc_message(botp: &BOTP, agent_addr: address, user_addr: address): vector<u8> {
        let agent = Table::borrow(&botp.agents, agent_addr);
        let otp_user = Table::borrow(&agent.users, user_addr);
        otp_user.enc_message_otp
    }

    /// Set history of user-agent communication
    public fun set_history(agent_addrs: vector<address>, user_addrs: vector<address>, ids: vector<vector<u8>>, enc_messages: vector<vector<u8>>, signatures: vector<vector<u8>>) {
        let length = vector::length(&signatures);

        let mut i: u64 = 0;
        while (i < length) {
            let agent_addr = vector::borrow(&agent_addrs, i);
            let user_addr = vector::borrow(&user_addrs, i);
            let id = vector::borrow(&ids, i);
            let enc_message = vector::borrow(&enc_messages, i);
            let signature = vector::borrow(&signatures, i);

            history_event(*agent_addr, *user_addr, *id, *enc_message, *signature);

            i = i + 1;
        }
    }

}
