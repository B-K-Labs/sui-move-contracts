module forge::forge {
    // Part 1: imports
    use sui::object;
    use sui::tx_context;

    // Part 2: struct definitions with public visibility
    public struct Sword has key, store {
        id: object::UID,
        magic: u64,
        strength: u64,
    }

    public struct Forge has key, store {
        id: object::UID,
        swords_created: u64,
    }

    // Part 3: internal initializer for module
    fun init(ctx: &mut tx_context::TxContext) {
        let admin = Forge {
            id: object::new(ctx),
            swords_created: 0,
        };
        // transfer the forge object to the module/package publisher
        sui::transfer::transfer(admin, tx_context::sender(ctx));
    }

    // Part 4: accessors required to read the struct attributes
    public fun magic(self: &Sword): u64 {
        self.magic
    }

    public fun strength(self: &Sword): u64 {
        self.strength
    }

    public fun swords_created(self: &Forge): u64 {
        self.swords_created
    }

    // Part 5: public/entry functions
    public entry fun sword_create(forge: &mut Forge, magic: u64, strength: u64, recipient: address, ctx: &mut tx_context::TxContext) {
        // create a sword
        let sword = Sword {
            id: object::new(ctx),
            magic: magic,
            strength: strength,
        };
        forge.swords_created = forge.swords_created + 1;
        sui::transfer::transfer(sword, recipient);
    }
}
