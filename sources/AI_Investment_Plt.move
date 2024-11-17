module AiInvestment::AiInvestment{

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the AI Investment Platform.
    struct InvestmentPlatform has store, key {
        total_invested: u64,  // Total funds invested in the platform
        target_goal: u64,     // Funding target of the platform
    }

    /// Initializes the AI Investment Platform with a funding goal.
    public fun initialize_platform(owner: &signer, goal: u64) {
        let platform = InvestmentPlatform {
            total_invested: 0,
            target_goal: goal,
        };
        move_to(owner, platform);
    }

    /// Allows users to invest in the platform.
    public fun invest(investor: &signer, platform_owner: address, amount: u64) acquires InvestmentPlatform {
        let platform = borrow_global_mut<InvestmentPlatform>(platform_owner);

        // Transfer the investment from the investor to the platform owner
        let investment = coin::withdraw<AptosCoin>(investor, amount);
        coin::deposit<AptosCoin>(platform_owner, investment);

        // Update the total funds invested
        platform.total_invested = platform.total_invested + amount;
    }
}
