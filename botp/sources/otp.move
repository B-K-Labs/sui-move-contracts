module OTP {

    use 0x1::Signer;
    use OTPUser::{create_user, update_profile, get_profile, get_role};
    use Std::string;
    use Std::address;

    struct User {
        enc_message_otp: vector<u8>
    }

    struct Agent has key {
        users: table::Table<address, User>
    }

    struct OTP has key {
        agents: table::Table<address, Agent>
    }

    /// Events
    public fun register_event(address_user: address, role: u64, profile: vector<u8>) {
        // Equivalent to Solidity's `emit Register`
        event Register(address_user, role, profile);
    }

    public fun profile_event(address_user: address, profile: vector<u8>) {
        // Equivalent to Solidity's `emit Profile`
        event Profile(address_user, profile);
    }

    public fun broadcast_event(agent_addr: address, user_addr: address, id: vector<u8>, enc_message: vector<u8>) {
        // Equivalent to Solidity's `emit Broadcast`
        event Broadcast(agent_addr, user_addr, id, enc_message);
    }

    public fun history_event(agent_addr: address, user_addr: address, id: vector<u8>, enc_message: vector<u8>, signature: vector<u8>) {
        // Equivalent to Solidity's `emit History`
        event History(agent_addr, user_addr, id, enc_message, signature);
    }

    /// Initialize OTP contract
    public fun initialize_otp(account: &signer): OTP {
        OTP {
            agents: table::new()
        }
    }

    /// Register User
    public fun register_user(storage: &mut OTPUser::Storage, signer: &signer, role: u64, profile: vector<u8>) {
        let sender = Signer::address_of(signer);
        create_user(storage, sender, role);
        update_profile(storage, sender, profile);
        register_event(sender, role, profile);
    }

    /// Update User Profile
    public fun update_user_profile(storage: &mut OTPUser::Storage, signer: &signer, profile: vector<u8>) {
        let sender = Signer::address_of(signer);
        update_profile(storage, sender, profile);
        profile_event(sender, profile);
    }

    /// Get User Profile
    public fun get_user_profile(storage: &OTPUser::Storage, user_addr: address): vector<u8> {
        get_profile(storage, user_addr)
    }

    /// Send Encrypted Messages
    public fun send_enc_message(otp: &mut OTP, storage: &OTPUser::Storage, signer: &signer, user_addrs: vector<address>, ids: vector<vector<u8>>, enc_messages: vector<vector<u8>>) {
        let sender = Signer::address_of(signer);
        let role = get_role(storage, sender);
        assert!(role == 1, b"You are not an agent");

        let agent = table::borrow_mut(&mut otp.agents, sender);
        let length = vector::length(&enc_messages);

        let mut i: u64 = 0;
        while (i < length) {
            let user_addr = vector::borrow(&user_addrs, i);
            let enc_message = vector::borrow(&enc_messages, i);
            let id = vector::borrow(&ids, i);

            let user = table::borrow_mut(&mut agent.users, *user_addr);
            user.enc_message_otp = *enc_message;
            
            broadcast_event(sender, *user_addr, *id, *enc_message);

            i = i + 1;
        }
    }

    /// Get Encrypted Message for a User
    public fun get_enc_message(otp: &OTP, agent_addr: address, user_addr: address): vector<u8> {
        let agent = table::borrow(&otp.agents, agent_addr);
        let user = table::borrow(&agent.users, user_addr);
        user.enc_message_otp
    }

    /// Set History for a User
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