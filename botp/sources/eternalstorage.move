module EternalStorage {

    /// Internal tables used to store different types of data
    resource struct Storage {
        uint_storage: table::Table<address, u64>,
        string_storage: table::Table<address, vector<u8>>,
        address_storage: table::Table<address, address>,
        bytes_storage: table::Table<address, vector<u8>>,
        bool_storage: table::Table<address, bool>,
        int_storage: table::Table<address, i128>,
        bytes32_storage: table::Table<address, vector<u8>>,
        bytes32_array_storage: table::Table<address, vector<vector<u8>>>,
        uint_array_storage: table::Table<address, vector<u64>>,
        address_array_storage: table::Table<address, vector<address>>,
        string_array_storage: table::Table<address, vector<vector<u8>>>,
    }

    /// Initialize the resource
    public fun initialize_storage(account: &signer): Storage {
        Storage {
            uint_storage: table::new<address, u64>(),
            string_storage: table::new<address, vector<u8>>(),
            address_storage: table::new<address, address>(),
            bytes_storage: table::new<address, vector<u8>>(),
            bool_storage: table::new<address, bool>(),
            int_storage: table::new<address, i128>(),
            bytes32_storage: table::new<address, vector<u8>>(),
            bytes32_array_storage: table::new<address, vector<vector<u8>>>(),
            uint_array_storage: table::new<address, vector<u64>>(),
            address_array_storage: table::new<address, vector<address>>(),
            string_array_storage: table::new<address, vector<vector<u8>>>(),
        }
    }

    /// Set functions for different types
    public fun set_uint(storage: &mut Storage, key: address, value: u64) {
        table::add(&mut storage.uint_storage, key, value);
    }

    public fun set_string(storage: &mut Storage, key: address, value: vector<u8>) {
        table::add(&mut storage.string_storage, key, value);
    }

    public fun set_address(storage: &mut Storage, key: address, value: address) {
        table::add(&mut storage.address_storage, key, value);
    }

    public fun set_bytes(storage: &mut Storage, key: address, value: vector<u8>) {
        table::add(&mut storage.bytes_storage, key, value);
    }

    public fun set_bool(storage: &mut Storage, key: address, value: bool) {
        table::add(&mut storage.bool_storage, key, value);
    }

    public fun set_int(storage: &mut Storage, key: address, value: i128) {
        table::add(&mut storage.int_storage, key, value);
    }

    public fun set_bytes32(storage: &mut Storage, key: address, value: vector<u8>) {
        table::add(&mut storage.bytes32_storage, key, value);
    }

    /// Get functions for different types
    public fun get_uint(storage: &Storage, key: address): u64 acquires Storage {
        table::borrow(&storage.uint_storage, key)
    }

    public fun get_string(storage: &Storage, key: address): vector<u8> acquires Storage {
        table::borrow(&storage.string_storage, key)
    }

    public fun get_address(storage: &Storage, key: address): address acquires Storage {
        table::borrow(&storage.address_storage, key)
    }

    public fun get_bytes(storage: &Storage, key: address): vector<u8> acquires Storage {
        table::borrow(&storage.bytes_storage, key)
    }

    public fun get_bool(storage: &Storage, key: address): bool acquires Storage {
        table::borrow(&storage.bool_storage, key)
    }

    public fun get_int(storage: &Storage, key: address): i128 acquires Storage {
        table::borrow(&storage.int_storage, key)
    }

    public fun get_bytes32(storage: &Storage, key: address): vector<u8> acquires Storage {
        table::borrow(&storage.bytes32_storage, key)
    }

    /// Array management functions (set, push, delete)
    public fun push_array_address(storage: &mut Storage, key: address, value: address) {
        let array = table::borrow_mut(&mut storage.address_array_storage, key);
        vector::push_back(array, value);
    }

    public fun delete_array_address(storage: &mut Storage, key: address, index: u64) {
        let array = table::borrow_mut(&mut storage.address_array_storage, key);
        let len = vector::length(array);
        assert!(index < len, 1);
        let last_index = len - 1;
        let last_value = vector::pop_back(array);
        vector::swap(array, index, last_index);
    }

    /// Set array at index
    public fun set_array_index_value(storage: &mut Storage, key: address, index: u64, value: address) {
        let array = table::borrow_mut(&mut storage.address_array_storage, key);
        let len = vector::length(array);
        assert!(index < len, 1);
        vector::borrow_mut(array, index) = value;
    }
}
