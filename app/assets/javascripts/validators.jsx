const isDollar= 'isDollar';
const isDecimal= 'isDecimal';
const isPostalOrZip = 'isPostalOrZip';

const hasTags = 'hasTags';

function isEmpty(value) {
    return !value || value === '';
}

function validateRegex(regex, value) {
    return regex.test(value);
}

function validateDollars(value) {
    //will accept dollar amounts with two digits after the decimal or no decimal
    //will also accept a number with or without a dollar sign
    var regex  = /^\$?[0-9]+(\.[0-9][0-9])?$/;
    return validateRegex(regex, value);
}

function validateDecimals(value) {
    // does not allow negative
    var regex  = /^[0-9]+(\.[0-9]{0,2})?$/;
    return validateRegex(regex, value);
}

function validatePostal(value) {
    // does not allow negative
    var regex  = /[a-zA-Z]{1}\d{1}[a-zA-Z]{1}[ ]{0,1}\d{1}[a-zA-Z]{1}\d{1}/;
    return validateRegex(regex, value);
}

function validateZip(value) {
    // does not allow negative
    var regex  = /^\d{5}(?:[-\s]\d{4})?$/;
    return validateRegex(regex, value);
}

Formsy.addValidationRule(isDollar, (values, value) => {
    if (isEmpty(value))
        return true;

    return validateDollars(value);
});

Formsy.addValidationRule(isDecimal, (values, value) => {
    if (isEmpty(value))
        return true;

    return validateDecimals(value);
});

Formsy.addValidationRule(isPostalOrZip, (values, value) => {
    if (isEmpty(value))
        return true;
    if (validatePostal(value))
        return true;

    return validateZip(value);
});

Formsy.addValidationRule(hasTags, (values, value) => {
    // console.log("values: " + JSON.stringify(values));
    // console.log("vlaue: " + JSON.stringify(value));
    if (isEmpty(value))
        return true;

    // if they have entered someting and it equates to nothing, error
    if (value.trim() === '')
        return false;
    return true;
});

