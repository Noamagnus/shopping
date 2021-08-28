void main() {
  print(buildPiramid('code', 16, twoSides: false));
}

String buildPiramid(String char, int height, {bool twoSides = false}) {
  String whiteSpace = ' ';
  String returnString = '';
  if (char.length > 4) {
    return ('Character cant be longer then 1');
  }
  if (height > 50) {
    return ('Height must be less than 50');
  }

  for (var i = 0; i < height; i++) {
    returnString +=
        whiteSpace * char.length * (height - i + 1) + char.toString() * (i + 1);
    if (twoSides) {
      returnString +=
          whiteSpace * 2 + char * (i + 1) + whiteSpace * (height - i + 1);
    }
    returnString += '\n';
  }

  return returnString;
}

// void main(){
//   String result=isNumberOddTernary(7);
//   print(result);
// }
//
// String isOdd(int num){
//   if(num%2==0){
//     return('Number is even');
//   }else{
//     return('Number is odd');
//   }
// }
//
// String isNumberOddTernary(int num){
//   return num%2==0? 'Number is even':'Number is odd';
// }
//
// String isNumberOddArrow(int num)=>num%2==0?'Number is even':'Number is odd';

// void main() {
//   List<int> myNumbers=[1,2,3,4,5];
//   int square(int i)=>i*i;
//   List<int> squareList= myNumbers.map(square).toList();
//   print(squareList);
//   List<int> biggerThenTen = squareList.where((e)=>e>10).toList();
//   print(biggerThenTen);
// }

// void main() {
//
//   List finalList=[];
//   for(var i=0; i<25;i++){
//     for(var min=0; min<4; min++){
//       if(i<10){
//         String helper= i.toString();
//
//         min ==0? helper='0'+helper+':00':helper='0'+helper+':'+(min*15).toString();
//
//         finalList.add(helper);
//
//       } else{
//         String helper2 =min ==0? i.toString()+':00':i.toString()+':'+(min*15).toString();
//         finalList.add(helper2);
//       }}
//
//   }
//   finalList.forEach((e){print(e);});
// }

//
// void main() {
//
//   List<String> getHours(){
//     List quarters =['00','15','30','45'];
//     List<String> returningList=[];
//     String help='';
//     int hours=1;
//
//     for(var i=0;i<24*4;i++){
//       hours=i~/4;
// //     print(hours);
//       if(i%4==0){
//         help ='${hours}:00';
//         returningList.add(help);
//       }else{
//         help ='${hours}:${quarters[i-hours*4]}';
//         returningList.add(help);
//       }
//
//     };
//     return returningList;
//   }
//   print(getHours());
// }

// void main() {
//
//   List<String> getHours(){
//     List quarters =['00','15','30','45'];
//     List<String> returningList=[];
//     String help='';
//     int hours=1;
//
//     for(var i=0;i<24*4;i++){
//       hours=i~/4;
//       if(hours>0){
//         help='${hours>9?hours:'0$hours:'}';
//       }else{
//         help='00:';
//       }
//       help+=quarters[i%4];
//       returningList.add(help);
//     }
//     return returningList;
//   }
//
//   void getHours2(){
//     List quarters =['00','15','30','45'];
//     List<String> returningList=[];
//     String help='';
//     int hours=1;
//
//     for(var i=0;i<24*4;i++){
//       print('moduo je ${i%4} and i is $i');
//     }
//   }
//
//
//   print(getHours());
// //   getHours2();
//
// }
///Best solution regarding getHours challenge
// void main() {
//
//   List<String> getHours(){
//     List quarters =['00','15','30','45'];
//     List<String> returningList=[];
//     String help='';
//     int hours=1;
//
//     for(var i=0;i<24*4;i++){
//       hours=i~/4;
//
//       help='${hours>9?'$hours:':'0$hours:'}';
//
//       help+=quarters[i%4];
//       returningList.add(help);
//     }
//     return returningList;
//   }
//   print(getHours());
//
// }
