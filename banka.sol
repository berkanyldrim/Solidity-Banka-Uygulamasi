pragma solidity ^ 0.6.0;

contract banka{
    
    //ödemeleri tek tek aldık.
    struct Payment{
        uint amount;
        uint timesTamp;
        
    }
    
    //ödemeleri genel bir toplam içerisine aldık.
    struct balance{
        uint totalBalance;
        uint numpayment;
        mapping(uint=>Payment) payments;
        
    }
    
    //herkesi kendi adresine göre indexleme yaptık.
    address owner;
    mapping(address=>balance) balanceRecieved;
    
    
    function recive() payable external{
        Payment memory py= Payment(now,msg.value); //ödeme yapan kişinin o anki ödemesini kayıt ediyoruz.
        balanceRecieved[msg.sender].totalBalance+=msg.value; // totalbalancenin ne kadar arttığını buluyoruz.
        balanceRecieved[msg.sender].payments[balanceRecieved[msg.sender].numpayment]=py; //kaçıncı ödeme olduğunu belirliyoruz.(hangisinin kaçıncı numara olduğu)
        balanceRecieved[msg.sender].numpayment++;
        
    }
    
    // contracttaki adresin toplam balance gösteren fonk.
    function getTotalBalance() public view returns(uint,address){
        
        return(address(this).balance,address(this));
        
    }
    
    //kullanıcıların balance gösteren fonk.
    function gelBalanceMsg() public view returns (uint,address){
        
        return(balanceRecieved[msg.sender].totalBalance,msg.sender);
    }
    
    //her kullanıcın göndereceği 'ether' kontrolü yapıyoruz.  
    function withdrawMsg(address payable _to, uint _amount) public {
        
        require(balanceRecieved[msg.sender].totalBalance>_amount,"Yeterli Bakiyeniz YOK !!"); // gönderen kişinin toplam balance'si gönderceği değerden büyük olmaliki ether göndersin.
        _to.transfer(_amount);
        balanceRecieved[msg.sender].totalBalance -= _amount; //gönderen kişinin gönderdiği miktar kadar hesabından gitmeli.
        
    }
    
    modifier onlyOwner(){
        require(owner==msg.sender,"Kontratin Sahibi Degilsiniz !!");
        _;
    }
    constructor() public{ owner==msg.sender;}
    
    function withdrawAll() public onlyOwner{
       msg.sender.transfer(address(this).balance); // bütün balance gönderdik
       selfdestruct(msg.sender);
       
        
    }
    
}