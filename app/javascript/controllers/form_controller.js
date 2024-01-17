import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // this.element.textContent = "Hello World!"
  }

  // Handle Submit button
  submitForm(event) {
    event.preventDefault();

    const upcCodeInput = this.element.querySelector('[name="product[upc_code]"]');

    if (upcCodeInput) {
      const upcCodeValue = upcCodeInput.value;
      
      // If UPC code is blank
      if (upcCodeValue === '') {
        this.displayErrorAlert("UPC code can't be blank");
        return;
      }

      // If UPC code already exist in db
      fetch(`/products/validate_upc_code/${encodeURIComponent(upcCodeValue)}`)
      .then(response => response.json())
      .then(data => {
        if (data.exists) {
            this.displayErrorAlert("UPC code already exists");
        } else {
            Swal.fire({
                title: 'Confirm adding a product',
                text: 'Are you sure you want to add this product?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, add it',
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Loading...',
                        allowOutsideClick: false,
                        showConfirmButton: false,
                        willOpen: () => {
                            Swal.showLoading();
                        },
                    });

                    // If confirmed, fetch data and add to database
                    fetch(`/products/fetch_product_info/${encodeURIComponent(upcCodeValue)}`)
                    .then((response) => response.json())
                    .then((data) => {
                    if (data.error) {
                        this.displayErrorAlert(data.error);
                    } else {
                        Swal.fire({
                            icon: 'success',
                            title: 'Successfully adding a product',
                            text: data.product.product_name + ' - ' + data.product.brand + ' - ' + data.product.quantity,
                            // imageUrl: data.product.image_url,
                            // imageAlt: "Product image"
                        });
                        upcCodeInput.value = '';             
                    }
                    })
                    .catch((error) => {
                        // If UPC code didn't found
                        console.error(error);
                        this.displayErrorAlert("Product didn't found!");
                    });
                }
             });   
        }
      })
      .catch(error => {
        console.error('Error validating UPC code:', error);
      });
    }
  }

  // Handle Cancel button
  cancelForm(event) {
    event.preventDefault()

    // Empty the UPC Code input
    const upcCodeInput = this.element.querySelector('[name="product[upc_code]"]');
    if (upcCodeInput) {
      upcCodeInput.value = '';
    }

    console.log('Form canceled!');
  }

  // Display error message
  displayErrorAlert(errorMessage) {
    Swal.fire({
      icon: 'error',
      title: 'Failed to add product',
      text: errorMessage || 'Something went wrong!'
    });
  }
}