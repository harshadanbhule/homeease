

import 'package:homease/model/service_model.dart';
import 'package:homease/model/sub_service_model.dart';

List<Service> services = [
  Service(
    id: 'srv001',
    name: 'AC Service',
    image: 'assets/service/ac.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'AC Repair',
        image: 'assets/subservice/ac/ac repair.png',
        price: 299.0,
        description: 'Complete AC repair inspection',
      ),
      SubService(
        id: 'sub002',
        name: 'AC Service',
        image: 'assets/subservice/ac/ac service.png',
        price: 799.0,
        description: 'Proper service of  AC unit',
      ),
    
    ],
  ),
  Service(
    id: 'srv002',
    name: 'Cleaning Service',
    image: 'assets/service/cleaning.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Home Cleaning',
        image: 'assets/subservice/cleaning/carpet cleaning.png',
        price: 299.0,
        description: 'Complete home cleaning',
      ),
      SubService(
        id: 'sub002',
        name: 'Carpet Cleaning',
        image: 'assets/subservice/cleaning/home.png',
        price: 799.0,
        description: 'proper carpet cleaning',
      ),
    
    ],
  ),
  
  
];


