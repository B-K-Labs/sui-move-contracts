module OTPUser {

    use EternalStorage::{Storage, set_bool, set_uint, set_address, set_string, get_bool, get_uint, get_string};
    use Encoder::{get_key};

    const USERID: vector<u8> = b"USERID";
    const ROLE: vector<u8> = b"ROLE";
    const PROFILE: vector<u8> = b"PROFILE";
    const PARTNER: vector<u8> = b"PARTNER";

    resource struct OTPUser {
        eternal_storage: Storage
    }

    /// Initialize the OTPUser resource with EternalStorage
    public fun initialize_user_storage(account: &signer, eternal_storage: Storage): OTPUser {
        OTPUser {
            eternal_storage
        }
    }

    /// Helper function to get user key
    public fun user_key(user_addr: address): vector<u8> {
        get_key(USERID, user_addr)
    }

    /// Check if a user exists
    public fun is_user(storage: &Storage, user_addr: address): bool {
        let key = user_key(user_addr);
        get_bool(&storage, key)
    }

    /// Create a new user with role
    public fun create_user(storage: &mut Storage, user_addr: address, role: u64): bool {
        assert!(!is_user(storage, user_addr), b"User already exists");
        
        // Initialize user in eternal storage
        set_bool(storage, user_key(user_addr), true);

        assert!(role < 3, b"Invalid role"); // Role: 0,1,2
        // Set role
        set_uint(storage, get_key(ROLE, user_addr), role);

        // Initialize partner as self
        set_bool(storage, get_key(PARTNER, user_addr, user_addr), true);

        true
    }

    /// Update the user's profile
    public fun update_profile(storage: &mut Storage, user_addr: address, profile: vector<u8>): bool {
        assert!(is_user(storage, user_addr), b"User does not exist");

        // Set profile
        set_string(storage, get_key(PROFILE, user_addr), profile);
        true
    }

    /// Set a partner for a user
    public fun set_partner(storage: &mut Storage, user_addr: address, partner_addr: address): bool {
        assert!(is_user(storage, user_addr), b"User does not exist");

        // Set address partner
        set_bool(storage, get_key(PARTNER, user_addr, partner_addr), true);
        true
    }

    /// Get the role of a user
    public fun get_role(storage: &Storage, user_addr: address): u64 {
        assert!(is_user(storage, user_addr), b"User does not exist");

        // Get role
        get_uint(storage, get_key(ROLE, user_addr))
    }

    /// Get the profile of a user
    public fun get_profile(storage: &Storage, user_addr: address): vector<u8> {
        assert!(is_user(storage, user_addr), b"User does not exist");

        // Get profile
        get_string(storage, get_key(PROFILE, user_addr))
    }

    /// Check if two addresses are partners
    public fun check_partner(storage: &Storage, user_addr: address, partner_addr: address): bool {
        assert!(is_user(storage, user_addr), b"User does not exist");

        // Get partner status
        get_bool(storage, get_key(PARTNER, user_addr, partner_addr))
    }
}
