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
        price: 599.0,
        description: 'Complete AC repair inspection',
      ),
      SubService(
        id: 'sub002',
        name: 'AC Service',
        image: 'assets/subservice/ac/ac service.png',
        price: 999.0,
        description: 'Proper service of  AC unit',
      ),
      SubService(
        id: 'sub003',
        name: 'Installation',
        image: 'assets/subservice/ac/installation.png',
        price: 799.0,
        description: 'Complete AC installation',
      ),
      SubService(
        id: 'sub004',
        name: 'Uninstallation',
        image: 'assets/subservice/ac/uninstallation.png',
        price: 799.0,
        description: 'Expert AC unstalling',
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
        image: 'assets/subservice/cleaning/home_cleaning.png',
        price: 2999.0,
        description: 'Complete cleaning service for your home',
      ),
      SubService(
        id: 'sub002',
        name: 'Carpet Cleaning',
        image: 'assets/subservice/cleaning/carpet cleaning.png',
        price: 1999.0,
        description: 'Complete cleaning service for your carpet',
      ),
      SubService(
        id: 'sub003',
        name: 'Bathroom Cleaning',
        image: 'assets/subservice/cleaning/faucet_bathroom_cleaning.png',
        price: 599.0,
        description: 'Complete bathroom and toilet cleaning',
      ),
      SubService(
        id: 'sub004',
        name: 'Kitchen Cleaning',
        image: 'assets/subservice/cleaning/kitchen_cleaning.png',
        price: 1999.0,
        description: 'Complete kitchen and tiles cleaning',
      ),
      SubService(
        id: 'sub005',
        name: 'Sofa Cleaning',
        image: 'assets/subservice/cleaning/sofa_cleaning.png',
        price: 299.0,
        description: 'Clean sofa and furnitures',
      ),
    
    ],
  ),
  //hola amigo
  Service(
    id: 'srv003',
    name: 'Appliance',
    image: 'assets/service/appliances.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'AC repairing',
        image: 'assets/subservice/appliances/ac_repair.png',
        price: 299.0,
        description: 'Repair AC',
      ),
      SubService(
        id: 'sub002',
        name: 'Refrigerator Repair',
        image: 'assets/subservice/appliances/fridge_repair.png',
        price: 999.0,
        description: 'Refrigerator Maintainance',
      ),
      SubService(
        id: 'sub003',
        name: 'Oven Repair',
        image: 'assets/subservice/appliances/oven_repair.png',
        price: 599.0,
        description: 'Repair Oven and microwave',
      ),
      SubService(
        id: 'sub004',
        name: 'Washing Machine Repair',
        image: 'assets/subservice/appliances/washing_machine_repai.png',
        price: 699.0,
        description: 'Maintain Washing machine',
      ),
      SubService(
        id: 'sub005',
        name: 'Water Purifier',
        image: 'assets/subservice/appliances/water_purifier_repair.png',
        price: 399.0,
        description: 'Clean Drinking water',
      ),
    
    ],
  ),
  Service(
    id: 'srv004',
    name: 'Painting',
    image: 'assets/service/paint.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Interior Painting',
        image: 'assets/subservice/painting/interior_painting.png',
        price: 4999.0,
        description: 'Paint indoor walls',
      ),
      SubService(
        id: 'sub002',
        name: 'Exterior Painting',
        image: 'assets/subservice/painting/exterior_painting.png',
        price: 7999.0,
        description: 'Paint outdoors',
      ),
      SubService(
        id: 'sub003',
        name: 'Texture Painting',
        image: 'assets/subservice/painting/texture_painting.png',
        price: 3999.0,
        description: 'Texturing wall designs ',
      ),
      SubService(
        id: 'sub004',
        name: 'Metal & Wood Painting',
        image: 'assets/subservice/painting/wood-metal_painting.png',
        price: 5999.0,
        description: 'Color woods & metal items',
      ),
      SubService(
        id: 'sub005',
        name: 'Waterproofing Painting',
        image: 'assets/subservice/painting/waterproof_painting.png',
        price: 9999.0,
        description: 'Waterproofing',
      ),
    
    ],
  ),
  Service(
    id: 'srv005',
    name: 'Plumbing',
    image: 'assets/service/plumbing.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Leakage Fixing',
        image: 'assets/subservice/plumbing/leakage_fixing.png',
        price: 499.0,
        description: 'Fix leaking sinks',
      ),
      SubService(
        id: 'sub002',
        name: 'Drain Cleaning ',
        image: 'assets/subservice/plumbing/Drain Cleaning.png',
        price: 799.0,
        description: 'Clear pipe draining',
      ),
      SubService(
        id: 'sub003',
        name: 'Tap Installation',
        image: 'assets/subservice/plumbing/Tap & Faucet Installation.png',
        price: 199.0,
        description: 'Install tap and Faucets ',
      ),
      SubService(
        id: 'sub004',
        name: 'Bathroom Fitting',
        image: 'assets/subservice/plumbing/Bathroom Fittings .png',
        price: 499.0,
        description: 'Install bathroom fittings',
      ),
      SubService(
        id: 'sub005',
        name: 'Water Pump Repairing',
        image: 'assets/subservice/plumbing/Water Motor & Pump Repair.png',
        price: 799.0,
        description: 'Repair Water Pump & Suction Motor',
      ),
    
    ],
  ),
  Service(
    id: 'srv006',
    name: 'Electronics',
    image: 'assets/service/electronics.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'TV Installation & Wall Mounting',
        image: 'assets/subservice/elecronics/TV Installation & Wall Mounting.png',
        price: 199.0,
        description: 'Install TV & Sound System',
      ),
      SubService(
        id: 'sub002',
        name: 'Electrical Wiring & Fitting',
        image: 'assets/subservice/elecronics/Electrical Wiring & Fitting.png',
        price: 599.0,
        description: 'Complete Wiring Service',
      ),
      SubService(
        id: 'sub003',
        name: 'Fan Installation',
        image: 'assets/subservice/elecronics/Fan Installation.png',
        price: 299.0,
        description: 'Install fan & coolers',
      ),
      SubService(
        id: 'sub004',
        name: 'Light & Appliance Installation',
        image: 'assets/subservice/elecronics/Light & Appliance Installation.png',
        price: 199.0,
        description: 'Add Lighting Connections',
      ),
      SubService(
        id: 'sub005',
        name: 'CCTV & Security System Installation',
        image: 'assets/subservice/elecronics/CCTV & Security System Installation.png',
        price: 999.0,
        description: 'Install Security System',
      ),
    
    ],
  ),
  Service(
    id: 'srv007',
    name: 'Shifting',
    image: 'assets/service/shifting.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Home Shifting',
        image: 'assets/subservice/shifting/Home Shifting.png',
        price: 19999.0,
        description: 'Shifting Service',
      ),
      SubService(
        id: 'sub002',
        name: 'Office Relocation',
        image: 'assets/subservice/shifting/Office Relocation.png',
        price: 799.0,
        description: 'Reallocate Workspace',
      ),
      SubService(
        id: 'sub003',
        name: 'Furniture Dismantling & Reassembly',
        image: 'assets/subservice/shifting/Furniture Dismantling & Reassembly.png',
        price: 1999.0,
        description: 'Assemble Furniture',
      ),
      SubService(
        id: 'sub004',
        name: 'Packing Services',
        image: 'assets/subservice/shifting/Packing Services.png',
        price: 999.0,
        description: 'Packup Service',
      ),
      SubService(
        id: 'sub005',
        name: 'Local Pickup & Delivery',
        image: 'assets/subservice/shifting/Local Pickup & Delivery.png',
        price: 499.0,
        description: 'Pickup Locally',
      ),
    
    ],
  ),
  Service(
    id: 'srv008',
    name: 'Beauty',
    image: 'assets/service/beauty.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Pedicure',
        image: 'assets/subservice/beauty/pedicure.png',
        price: 699.0,
        description: 'Manicure & Pedicure Care',
      ),
      SubService(
        id: 'sub002',
        name: 'hair Styling',
        image: 'assets/subservice/beauty/hair_styling.png',
        price: 499.0,
        description: 'Style & Color hair',
      ),
      SubService(
        id: 'sub003',
        name: 'Beauty Care',
        image: 'assets/subservice/beauty/facial.png',
        price: 999.0,
        description: 'Facial & Scrub',
      ),
      SubService(
        id: 'sub004',
        name: 'Waxing',
        image: 'assets/subservice/beauty/waxing.png',
        price: 999.0,
        description: 'Waxing & Shaving',
      ),
      SubService(
        id: 'sub005',
        name: 'Bridal Makeup',
        image: 'assets/subservice/beauty/bridal_makeup.png',
        price: 2999.0,
        description: 'Walk-in Makeup for Speacial Occasion',
      ),
    
    ],
  ),
  Service(
    id: 'srv009',
    name: 'Men Salon',
    image: 'assets/service/men salon.png',
    subServices: [
      SubService(
        id: 'sub001',
        name: 'Haircut & Styling',
        image: 'assets/subservice/men_salon/Haircut & Stylin.png',
        price: 149.0,
        description: 'Cut & Style Hair',
      ),
      SubService(
        id: 'sub002',
        name: 'Hair Coloring',
        image: 'assets/subservice/men_salon/Hair Coloring.png',
        price: 99.0,
        description: 'Style & Color hair',
      ),
      SubService(
        id: 'sub003',
        name: 'Beard Grooming & Trimming',
        image: 'assets/subservice/men_salon/Beard Grooming & Trimming.png',
        price: 99.0,
        description: 'Style & Groom Beard',
      ),
      SubService(
        id: 'sub004',
        name: 'Head & Shoulder Massage',
        image: 'assets/subservice/men_salon/Head & Shoulder Massage.png',
        price: 499.0,
        description: 'Massage & Relaxing',
      ),
      SubService(
        id: 'sub005',
        name: 'Facial & Skincare',
        image: 'assets/subservice/men_salon/Facial & Skincare.png',
        price: 999.0,
        description: 'Skincare for Men',
      ),
    
    ],
  )
  
  
];