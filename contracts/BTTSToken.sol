pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// BTTS 'BokkyPooBah's Token Teleportation Service' token interface and
// sample implementation
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    uint public totalSupply;
    function balanceOf(address owner) public constant returns (uint balance);
    function transfer(address to, uint amount) public returns (bool success);
    function transferFrom(address from, address to, uint tokens)
        public returns (bool success);
    function approve(address spender, uint tokens)
        public returns (bool success);
    function allowance(address owner, address spender)
        public constant returns (uint remaining);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed owner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service (BTTS) Interface v1.00
//
// This consist of the signed message versions of the three ERC20 function:
// - signedTransfer(...)
// - signedApprove(...)
// - signedTransferFrom(...)
//
// Each of these signed message functions have a helper to generate the signed
// message hash:
// - signedTransferHash(...)
// - signedApproveHash(...)
// - signedTransferFromHash(...)
//
// Each of these signed message functions have a help to check the status of
// the signed message before the signed message functions are submitted for
// execution:
// - signedTransferCheck(...)
// - signedApproveCheck(...)
// - signedTransferFromCheck(...)
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
// ----------------------------------------------------------------------------
contract BTTSInterface {

    // ------------------------------------------------------------------------
    // Version
    // ------------------------------------------------------------------------
    uint public constant bttsVersion = 100;


    // ------------------------------------------------------------------------
    // signed{X}Check return status
    // ------------------------------------------------------------------------
    enum CheckResult {
        Success,                           // 0 Success
        NotTransferable,                   // 1 Tokens not transferable yet
        SignerMismatch,                    // 2 Mismatch in signing account
        AlreadyExecuted,                   // 3 Transfer already executed
        InsufficientApprovedTokens,        // 4 Insufficient approved tokens
        InsufficientApprovedTokensForFees, // 5 Insufficient approved tokens for fees
        InsufficientTokens,                // 6 Insufficient tokens
        InsufficientTokensForFees,         // 7 Insufficient tokens for fees
        OverflowError                      // 8 Overflow error
    }


    // ------------------------------------------------------------------------
    // signedTransfer functions
    //
    // Generate the hash used to create the signed transfer message
    // ------------------------------------------------------------------------
    function signedTransferHash(address owner, address to, uint tokens,
        uint fee, uint nonce) public view returns (bytes32 hash);

    // ------------------------------------------------------------------------
    // Check whether a transfer can be executed on behalf of the user who
    // signed the transfer message
    // ------------------------------------------------------------------------
    function signedTransferCheck(address owner, address to, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result);

    // ------------------------------------------------------------------------
    // Execute a transfer on behalf of the user who signed the transfer 
    // message
    // ------------------------------------------------------------------------
    function signedTransfer(address owner, address to, uint tokens, uint fee,
        uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success);


    // ------------------------------------------------------------------------
    // signedApprove functions
    //
    // Generate the hash used to create the signed approve message
    // ------------------------------------------------------------------------
    function signedApproveHash(address owner, address spender, uint tokens,
        uint fee, uint nonce) public view returns (bytes32 hash);

    // ------------------------------------------------------------------------
    // Check whether an approve can be executed on behalf of the user who
    // signed the approve message
    // ------------------------------------------------------------------------
    function signedApproveCheck(address owner, address spender, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result);

    // ------------------------------------------------------------------------
    // Execute an approve on behalf of the user who signed the approve message
    // ------------------------------------------------------------------------
    function signedApprove(address owner, address spender, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success);


    // ------------------------------------------------------------------------
    // signedTransferFrom functions
    //
    // Generate the hash used to create the signed transferFrom message
    // ------------------------------------------------------------------------
    function signedTransferFromHash(address spender, address from, address to,
        uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);

    // ------------------------------------------------------------------------
    // Check whether a transferFrom can be executed on behalf of the user who
    // signed the transferFrom message
    // ------------------------------------------------------------------------
    function signedTransferFromCheck(address spender, address from, address to,
        uint tokens, uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result);

    // ------------------------------------------------------------------------
    // Execute a transferFrom on behalf of the user who signed the transferFrom 
    // message
    // ------------------------------------------------------------------------
    function signedTransferFrom(address spender, address from, address to,
        uint tokens, uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success);
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {

    // ------------------------------------------------------------------------
    // Current owner, and proposed new owner
    // ------------------------------------------------------------------------
    address public owner;
    address public newOwner;

    // ------------------------------------------------------------------------
    // Constructor - assign creator as the owner
    // ------------------------------------------------------------------------
    function Owned() public {
        owner = msg.sender;
    }

    // ------------------------------------------------------------------------
    // Modifier to mark that a function can only be executed by the owner
    // ------------------------------------------------------------------------
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // ------------------------------------------------------------------------
    // Owner can initiate transfer of contract to a new owner
    // ------------------------------------------------------------------------
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    // ------------------------------------------------------------------------
    // New owner has to accept transfer of contract
    // ------------------------------------------------------------------------
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = 0x0;
    }
    event OwnershipTransferred(address indexed _from, address indexed _to);
}


/*
// ----------------------------------------------------------------------------
// Administrators
// ----------------------------------------------------------------------------
contract Admin is Owned {

    // ------------------------------------------------------------------------
    // Mapping of administrators
    // ------------------------------------------------------------------------
    mapping (address => bool) public admins;

    // ------------------------------------------------------------------------
    // Add and delete admin events
    // ------------------------------------------------------------------------
    event AdminAdded(address _address);
    event AdminRemoved(address _address);

    // ------------------------------------------------------------------------
    // Modifier for functions that can only be executed by adminstrator
    // ------------------------------------------------------------------------
    modifier onlyAdmin() {
        require(admins[msg.sender] || owner == msg.sender);
        _;
    }

    // ------------------------------------------------------------------------
    // Owner can add a new administrator
    // ------------------------------------------------------------------------
    function addAdmin(address _address) public onlyOwner {
        admins[_address] = true;
        AdminAdded(_address);
    }

    // ------------------------------------------------------------------------
    // Owner can remove an administrator
    // ------------------------------------------------------------------------
    function removeAdmin(address _address) public onlyOwner {
        delete admins[_address];
        AdminRemoved(_address);
    }
}
*/

// ----------------------------------------------------------------------------
// Safe maths, borrowed from OpenZeppelin
// ----------------------------------------------------------------------------
library SafeMath {

    // ------------------------------------------------------------------------
    // Add a number to another number, checking for overflows
    // ------------------------------------------------------------------------
    function add(uint a, uint b) public pure returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    // ------------------------------------------------------------------------
    // Subtract a number from another number, checking for underflows
    // ------------------------------------------------------------------------
    function sub(uint a, uint b) public pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    // ------------------------------------------------------------------------
    // Multiply two numbers
    // ------------------------------------------------------------------------
    function mul(uint a, uint b) public pure returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    // ------------------------------------------------------------------------
    // Multiply one number by another number
    // ------------------------------------------------------------------------
    function div(uint a, uint b) public pure returns (uint) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract ERC20Token is ERC20Interface, Owned {
    using SafeMath for uint;

    // ------------------------------------------------------------------------
    // Token parameters
    // ------------------------------------------------------------------------
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public decimalsFactor;
    uint public totalSupply;

    // ------------------------------------------------------------------------
    // Token contract state
    // ------------------------------------------------------------------------
    bool public mintable;
    bool public transferable;

    // ------------------------------------------------------------------------
    // Balances for each account
    // ------------------------------------------------------------------------
    mapping(address => uint) balances;

    // ------------------------------------------------------------------------
    // Owner of account approves the transfer of an amount to another account
    // ------------------------------------------------------------------------
    mapping(address => mapping(address => uint)) allowed;

    // ------------------------------------------------------------------------
    // Executed signed transfers
    // ------------------------------------------------------------------------
    mapping(address => mapping(bytes32 => bool)) public executed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function ERC20Token(string _symbol, string _name, uint8 _decimals, 
        uint _initialSupply, bool _mintable, bool _transferable) public 
    {
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
        decimalsFactor = 10**uint(_decimals);
        if (_initialSupply > 0) {
            balances[owner] = _initialSupply;
            totalSupply = _initialSupply;
            Transfer(0x0, owner, _initialSupply);
        }
        mintable = _mintable;
        transferable = _transferable;
    }


    // ------------------------------------------------------------------------
    // Disable minting
    // ------------------------------------------------------------------------
    function disableMinting() public onlyOwner {
        require(mintable);
        mintable = false;
    }


    // ------------------------------------------------------------------------
    // Enable transfers
    // ------------------------------------------------------------------------
    function enableTransfers() public onlyOwner {
        require(!transferable);
        transferable = true;
    }


    // ------------------------------------------------------------------------
    // Get the account balance of another account with address _owner
    // ------------------------------------------------------------------------
    function balanceOf(address owner) public constant returns (uint balance) {
        return balances[owner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        require(transferable);
        require(balances[msg.sender] >= tokens);

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Approve `spender` to withdraw `tokens` tokens from the owner's account
    //
    // As recommended in https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
    // there are no checks for the approval double-spend attack as this should
    // be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens)
        public returns (bool success) 
    {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // 
    
    // Spender of tokens transfer an amount of tokens from the token owner's
    // balance to another account. The owner of the tokens must already
    // have approve(...)-d this transfer
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens)
        public returns (bool success)
    {
        require(transferable);
        require(balances[from] >= tokens);
        require(allowed[from][msg.sender] >= tokens);

        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address owner, address spender)
        public constant returns (uint remaining)
    {
        return allowed[owner][spender];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from owner's account to another account
    // - Account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function mint(address to, uint tokens)
        public onlyOwner returns (bool success)
    {
        require(mintable);
        balances[to] = balances[to].add(tokens);
        totalSupply = totalSupply.add(tokens);
        Transfer(0x0, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Don't accept ethers - no payable modifier
    // ------------------------------------------------------------------------
    function () public {
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens)
      public onlyOwner returns (bool success)
    {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service (BTTS) Implementation v1.00
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
// ----------------------------------------------------------------------------
contract BTTSToken is ERC20Token, BTTSInterface {
    using SafeMath for uint;

    // ------------------------------------------------------------------------
    // Constants used for signing and recovery
    // ------------------------------------------------------------------------
    bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";

    // ------------------------------------------------------------------------
    // signedTransfer(...) function signature
    // web3.sha3("signedTransfer(address,address,uint256,uint256,uint256,uint8,bytes32,bytes32)").substring(0,10)
    // => "0xa64a9365"
    // ------------------------------------------------------------------------
    bytes4 public constant signedTransferSig = "\xa6\x4a\x93\x65";

    // ------------------------------------------------------------------------
    // signedApprove(...) function signature
    // web3.sha3("signedApprove(address,address,uint256,uint256,uint256,uint8,bytes32,bytes32)").substring(0,10)
    // => "0xb310efc3"
    // ------------------------------------------------------------------------
    bytes4 public constant signedApproveSig = "\xb3\x10\xef\xc3";

    // ------------------------------------------------------------------------
    // signedTransferFrom(...) function signature
    // web3.sha3("signedTransferFrom(address,address,address,uint256,uint256,uint256,uint8,bytes32,bytes32)").substring(0,10)
    // => "0xc6e5df0c"
    // ------------------------------------------------------------------------
    bytes4 public constant signedTransferFromSig = "\xc6\xe5\xdf\x0c";


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function BTTSToken(string _symbol, string _name, uint8 _decimals, 
        uint _initialSupply, bool _mintable, bool _transferable)
        public ERC20Token(_symbol, _name, _decimals, _initialSupply,
        _mintable, _transferable)
    {
    }


    // ------------------------------------------------------------------------
    // signedTransfer functions
    //
    // Generate the hash used to create the signed transfer message
    // ------------------------------------------------------------------------
    function signedTransferHash(address owner, address to, uint tokens,
        uint fee, uint nonce) public view returns (bytes32 hash)
    {
        hash = keccak256(signedTransferSig, address(this), owner, to, tokens,
            fee, nonce);
    }

    // ------------------------------------------------------------------------
    // Check whether a transfer can be executed on behalf of the user who
    // signed the transfer message
    // ------------------------------------------------------------------------
    function signedTransferCheck(address owner, address to, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result)
    {
        // Check tokens are transferable
        if (!transferable) return CheckResult.NotTransferable;

        // Check owner is the message signer
        bytes32 hash = signedTransferHash(owner, to, tokens, fee, nonce);
        if (owner != ecrecover(keccak256(signingPrefix, hash), v, r, s))
            return CheckResult.SignerMismatch;

        // Check message not already executed
        if (executed[owner][hash]) return CheckResult.AlreadyExecuted;

        uint total = tokens.add(fee);

        // Check there are sufficient tokens to transfer
        if (balances[owner] < tokens) return CheckResult.InsufficientTokens;

        // Check there are sufficient tokens to pay for fees
        if (balances[owner] < total)
            return CheckResult.InsufficientTokensForFees;

        // Check for overflows
        if (balances[to] + tokens < balances[to])
            return CheckResult.OverflowError;
        if (balances[msg.sender] + fee < balances[msg.sender])
            return CheckResult.OverflowError;

        return CheckResult.Success;
    }

    // ------------------------------------------------------------------------
    // Execute a transfer on behalf of the user who signed the transfer
    // message
    // ------------------------------------------------------------------------
    function signedTransfer(address owner, address to, uint tokens, uint fee,
        uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success)
    {
        // Check tokens are transferable
        require(transferable);

        // Check owner is the message signer
        bytes32 hash = signedTransferHash(owner, to, tokens, fee, nonce);
        require(owner == ecrecover(keccak256(signingPrefix, hash), v, r, s));

        // Check message not already executed
        require(!executed[owner][hash]);
        executed[owner][hash] = true;

        // Move the tokens and fees
        require(balances[owner] >= tokens);
        balances[owner] = balances[owner].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(owner, to, tokens);

        // Fee
        require(balances[owner] >= fee);
        balances[owner] = balances[owner].sub(fee);
        balances[msg.sender] = balances[msg.sender].add(fee);
        Transfer(owner, msg.sender, fee);

        return true;
    }


    // ------------------------------------------------------------------------
    // signedApprove functions
    //
    // Generate the hash used to create the signed approve message
    // ------------------------------------------------------------------------
    function signedApproveHash(address signer, address spender, uint tokens,
        uint fee, uint nonce) public view returns (bytes32 hash) 
    {
        hash = keccak256(signedApproveSig, address(this),
            signer, spender, tokens, fee, nonce);
    }

    // ------------------------------------------------------------------------
    // Check whether an approve can be executed on behalf of the user who
    // signed the approve message
    // ------------------------------------------------------------------------
    function signedApproveCheck(address owner, address spender, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result) 
    {
        // Check tokens are transferable
        if (!transferable) return CheckResult.NotTransferable;

        // Check owner is the message signer
        bytes32 hash = signedApproveHash(owner, spender, tokens, fee, nonce);
        if (owner != ecrecover(keccak256(signingPrefix, hash), v, r, s))
            return CheckResult.SignerMismatch;

        // Check message not already executed
        if (executed[owner][hash]) return CheckResult.AlreadyExecuted;

        // Check there are sufficient tokens to pay for fees
        if (balances[owner] < fee)
            return CheckResult.InsufficientTokensForFees;

        // Check for overflows
        if (balances[msg.sender] + fee < balances[msg.sender])
            return CheckResult.OverflowError;

        return CheckResult.Success;
    }

    // ------------------------------------------------------------------------
    // Execute an approve on behalf of the user who signed the approve message
    // ------------------------------------------------------------------------
    function signedApprove(address owner, address spender, uint tokens,
        uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success) 
    {
        // Check tokens are transferable
        require(transferable);

        // Check owner is the message signer
        bytes32 hash = signedApproveHash(owner, spender, tokens, fee, nonce);
        require(owner == ecrecover(keccak256(signingPrefix, hash), v, r, s));

        // Check message not already executed
        require(!executed[owner][hash]);
        executed[owner][hash] = true;

        // Approve
        allowed[owner][spender] = tokens;
        Approval(owner, spender, tokens);

        // Fee
        require(balances[owner] >= fee);
        balances[owner] = balances[owner].sub(fee);
        balances[msg.sender] = balances[msg.sender].add(fee);
        Transfer(owner, msg.sender, fee);

        return true;
    }


    // ------------------------------------------------------------------------
    // signedTransferFrom functions
    //
    // Generate the hash used to create the signed transferFrom message
    // ------------------------------------------------------------------------
    function signedTransferFromHash(address spender, address from, address to,
        uint tokens, uint fee, uint nonce) public view returns (bytes32 hash)
    {
        hash = keccak256(signedTransferFromSig, address(this),
            spender, from, to, tokens, fee, nonce);
    }

    // ------------------------------------------------------------------------
    // Check whether a transferFrom can be executed on behalf of the user who
    // signed the transferFrom message
    // ------------------------------------------------------------------------
    function signedTransferFromCheck(address spender, address from, address to,
        uint tokens, uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public constant returns (CheckResult result)
    {
        // Check tokens are transferable
        if (!transferable) return CheckResult.NotTransferable;

        // Check spender is the message signer
        bytes32 hash = signedTransferFromHash(spender, from, to, tokens, fee,
            nonce);
        if (spender != ecrecover(keccak256(signingPrefix, hash), v, r, s))
            return CheckResult.SignerMismatch;

        // Check message not already executed
        if (executed[spender][hash]) return CheckResult.AlreadyExecuted;

        uint total = tokens.add(fee);

        // Check there are sufficient approved tokens to transfer
        if (allowed[from][spender] < tokens)
            return CheckResult.InsufficientApprovedTokens;
        // Check there are sufficient approved tokens to pay for fees
        if (allowed[from][spender] < total)
            return CheckResult.InsufficientApprovedTokensForFees;

        // Check there are sufficient tokens to transfer
        if (balances[from] < tokens) return CheckResult.InsufficientTokens;

        // Check there are sufficient tokens to pay for fees
        if (balances[from] < total)
            return CheckResult.InsufficientTokensForFees;

        // Check for overflows
        if (balances[to] + tokens < balances[to])
            return CheckResult.OverflowError;
        if (balances[msg.sender] + fee < balances[msg.sender])
            return CheckResult.OverflowError;

        return CheckResult.Success;
    }


    // ------------------------------------------------------------------------
    // Execute a transferFrom on behalf of the user who signed the transferFrom 
    // message
    // ------------------------------------------------------------------------
    function signedTransferFrom(address spender, address from, address to,
        uint tokens, uint fee, uint nonce, uint8 v, bytes32 r, bytes32 s)
        public returns (bool success)
    {
        // Check tokens are transferable
        require(transferable);

        // Check spender is the message signer
        bytes32 hash = signedTransferFromHash(spender, from, to, tokens,
            fee, nonce);
        require(spender == ecrecover(keccak256(signingPrefix, hash), v, r, s));

        // Check message not already executed
        require(!executed[spender][hash]);
        executed[spender][hash] = true;

        uint total = tokens.add(fee);
        require(balances[from] >= total);
        require(allowed[from][spender] >= total);

        // Move the tokens and fees
        balances[from] = balances[from].sub(tokens);
        allowed[from][spender] = allowed[from][spender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(from, to, tokens);

        // Fee
        balances[from] = balances[from].sub(fee);
        allowed[from][spender] = allowed[from][spender].sub(fee);
        balances[msg.sender] = balances[msg.sender].add(fee);
        Transfer(from, msg.sender, fee);

        return true;
    }
}